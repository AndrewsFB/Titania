class_name Player
extends WorldObject

signal hp_change(old_value, new_value)
var max_hp = 100
var hp = 100

export var walk_speed := 100
export var run_speed := 300

export var jump_force := -400
export var super_jump_force := -3000
export var dash_force := 2000
export var dive_force := 1000

var velocity := Vector2.ZERO
var last_velocity := Vector2.ZERO

var facing_right := true

var can_jump := true
var can_dash := true

var seed_energy := 0
export var call_energy = false

var last_valid_position := Vector2.ZERO

onready var sprite = $Sprite
onready var aura = $Aura
onready var hitbox = $HitBox
onready var animation = $Animation
onready var visibility_notifier = $VisibilityNotifier
onready var state_machine = $StateMachine
onready var teleport_effect = $TeleportEffect
onready var teleport_timer = $TeleportTimer
onready var camera = $Camera2D
onready var air_trail = $AirTrail
onready var air_trail_audio = $AirTrail/Audio
onready var dive_dust = $StateMachine/Dive/Dust
onready var blood = $Sprite/Blood
onready var initial_walk_speed := walk_speed
onready var initial_run_speed := run_speed

func _ready():
	state_machine.init(self)


func _physics_process(delta):
	create_ghost_energy()
	
	if air_trail.visible and not air_trail_audio.playing:
		air_trail_audio.play()
	elif not air_trail.visible and air_trail_audio.playing:
		air_trail_audio.stop()
		
	if(velocity != Vector2.ZERO):
		last_velocity = velocity
	
	if(last_velocity.x != 0):
		if facing_right != (last_velocity.x >= 0):
			run_speed = initial_run_speed
			walk_speed = initial_walk_speed
		facing_right = last_velocity.x >= 0
	
	sprite.flip_h = not facing_right
	flip_sprite_children()
	
	velocity = .move(velocity)

	if state_machine.state.name == "Idle" and is_on_floor() and velocity == Vector2.ZERO:
		last_valid_position = position

	if not visibility_notifier.is_on_screen() and last_valid_position != Vector2.ZERO:
		Global.cancel_player_input = true
		teleport_effect.emitting = true
		sprite.visible = false
		position = last_valid_position
		yield(get_tree().create_timer(0.3), "timeout")
		teleport_effect.emitting = false
		sprite.visible = true
		Global.cancel_player_input = false

func _die():
	hp = max_hp


func flip_sprite_children():
	for child in sprite.get_children():
		if (not sprite.flip_h and child.scale.x < 0) or (sprite.flip_h and child.scale.x > 0):
			child.scale.x *= -1


func create_ghost_trail() -> void:
	var ghost_trail = load(Paths.UTIL_GHOST_TRAIL).instance()
	ghost_trail.global_position = sprite.global_position
	ghost_trail.flip_h = sprite.flip_h
	ghost_trail.texture = sprite.texture
	ghost_trail.scale = sprite.scale
	ghost_trail.hframes = sprite.hframes
	ghost_trail.vframes = sprite.vframes
	ghost_trail.frame = sprite.frame
	ghost_trail.z_index = sprite.z_index-1

	get_tree().get_root().add_child(ghost_trail)


func create_ghost_energy() -> void:
	if call_energy:
		aura.visible = true
		aura.material.set_shader_param("intensity", 1 + seed_energy / 10)
		seed_energy += 1
		var ghost_trail = load(Paths.UTIL_GHOST_TRAIL).instance()
		ghost_trail.global_position = sprite.global_position
		ghost_trail.global_position.y -= seed_energy
		ghost_trail.flip_h = sprite.flip_h
		ghost_trail.texture = sprite.texture
		ghost_trail.scale = sprite.scale
		ghost_trail.hframes = sprite.hframes
		ghost_trail.vframes = sprite.vframes
		ghost_trail.frame = sprite.frame
		ghost_trail.z_index = sprite.z_index-1
		
		if seed_energy == 10:
			seed_energy = 0

		get_tree().get_root().add_child(ghost_trail)
	else:
		aura.visible = false


func warp_to_position(destiny):
	last_valid_position = Vector2.ZERO
	get_tree().paused = true
	yield(get_tree().create_timer(0.5), "timeout")
	global_position = destiny
	get_tree().paused = false


func inflict_damage(damage, active_hurt_state = false):
	if is_on_floor():
		state_machine.transition_to("Hurt")
	var old_value = hp
	var new_value = hp - damage
	hp -= damage
	emit_signal("hp_change", max_hp, old_value, new_value)
	if hp <= 0:
		_die()
	if active_hurt_state:
		state_machine.transition_to("Hurt")
