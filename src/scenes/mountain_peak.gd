extends Level

var _player_speed := 400
var _make_ghost_trail := 0

onready var player = $Player
onready var path_follow = $Path2D/PathFollow2D
onready var explosion = $Explosion
onready var explosion_audio = $Explosion/Audio
onready var initial_camera = $InitialCamera
onready var wolf = $Wolf


func _ready():
	Global.is_playing_first_cutscene = true
	Global.is_playing_cutscene = true
	wolf.play()
	player.camera.current = false
	player.air_trail.visible = true
	player.animation.play("dash")
	player.air_trail.emitting = true
	player.apply_gravity = false
	_make_ghost_trail = true
	yield(get_tree().create_timer(2.0), "timeout")
	player.camera.smoothing_speed = 0.5
	initial_camera.current = false
	player.camera.current = true


func _physics_process(delta):
	path_follow.offset = path_follow.offset + 400 * delta
	player.global_position = path_follow.global_position
	
	if _make_ghost_trail:
		player.create_ghost_trail()


func _on_Trigger1_body_entered(body):
	if body.name == "Player":
		player.air_trail.visible = false
		explosion.emitting = true
		explosion_audio.play()
		player.animation.play("jump")
		_make_ghost_trail = true


func _on_Trigger2_body_entered(body):
	if body.name == "Player":
		player.animation.play("run")
		_player_speed = 280
		_make_ghost_trail = false


func _on_Trigger3_body_entered(body):
	if body.name == "Player":
		player.animation.play("jump")
		_make_ghost_trail = false


func _on_Trigger4_body_entered(body):
	if body.name == "Player":
		player.animation.play("fall")
		_make_ghost_trail = true
		transition.fade_out()


func _on_Trigger5_body_entered(body):
	if body.name == "Player":
		change_scene(Paths.SCENE_FOREST)


func _on_Trigger6_body_entered(body):
	if body.name == "Player":
		player.animation.play("extra_jump")
		_make_ghost_trail = false


func _on_Trigger7_body_entered(body):
	if body.name == "Player":
		hud.make_thought(dialogs.mountain_peak[0])


func _on_Trigger8_body_entered(body):
	if body.name == "Player":
		hud.make_thought(dialogs.mountain_peak[1])


func _on_Trigger9_body_entered(body):
	if body.name == "Player":
		player.camera.smoothing_speed = 5
		hud.visible = true
