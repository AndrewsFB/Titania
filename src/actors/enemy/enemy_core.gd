class_name EnemyCore
extends Node2D

var velocity := Vector2.ZERO
var last_velocity := Vector2.ZERO
var facing_right := true

var is_player_detected 
var is_destination_reached 

var _body : WorldObject
var _specs : Specs
var _player : Player
var _sprite : Sprite
var _slowdown_area : Area2D
var _animation : AnimationPlayer
var _blood : CPUParticles2D
var _death_particles : CPUParticles2D
var _hurt_audio : AudioStreamPlayer

onready var state_machine = $StateMachine
onready var audio_tween = $AudioTween

var pos setget set_pos, get_pos
var speed setget set_speed, get_speed
var flip_h setget set_flip_h, get_flip_h
var move_type setget set_move_type, get_move_type
var apply_gravity setget set_apply_gravity, get_apply_gravity


func _physics_process(delta):
	if _animation.current_animation == "die" and not _body.is_on_floor():
		velocity.y += 100
	velocity = _body.move(velocity)


func init(body, specs, player, sprite, animation, blood, death_particles, hurt_audio):
	_body = body
	_specs = specs
	_player = player
	_sprite = sprite
	_animation = animation
	_blood = blood
	_death_particles = death_particles
	_slowdown_area = _sprite.get_node("SlowdownArea")
	_hurt_audio = hurt_audio
	state_machine.init(self)


func play_animation(anim_name):
	_animation.play(anim_name)


func prepare_death():
	_body.remove_from_group("enemy")


func die():
	_body.queue_free()


func inflict_damage(damage):
	_specs.hp -= damage
	audio_tween.interpolate_property(_sprite, "modulate", Color(1, 1, 1, 1), Color(10, 0, 0, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	audio_tween.start()
	_blood.position.y = randi() % 8
	_blood.position.x = randi() % 4
	_blood.emitting = true
	_hurt_audio.play()
	audio_tween.interpolate_property(_sprite, "modulate",  Color(10, 0, 0, 1), Color(1, 1, 1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	audio_tween.start()
	if _specs.hp <= 0:
		state_machine.transition_to("Die")


func set_apply_gravity(new_value):
	_body.apply_gravity = new_value


func get_apply_gravity():
	return _body.apply_gravity


func set_move_type(new_value):
	_specs = new_value


func get_move_type():
	return _specs.move_type


func set_flip_h(new_value):
	_sprite.flip_h = new_value
	for child in _sprite.get_children():
		if (not new_value and child.scale.x < 0) or (new_value and child.scale.x > 0):
			child.scale.x *= -1


func get_flip_h() -> bool:
	return _sprite.flip_h


func set_speed(new_value):
	_specs.speed = new_value


func get_speed() -> int:
	return _specs.speed


func set_pos(new_value):
	_body.position = new_value


func get_pos() -> Vector2:
	return _body.position


func get_player_pos() -> Vector2:
	return _player.global_position


func animation_is_playing() -> bool:
	return _animation.is_playing()


func disable_slowdown_area() -> void:
	_slowdown_area.monitoring = false


func _on_HurtArea_body_entered(body):
	if body.is_in_group("player"):
		body.inflict_damage(_specs.attack)


func _on_TargetArea_body_entered(body):
	if body.is_in_group("player"):
		is_destination_reached = true


func _on_SlowdownArea_body_entered(body):
	if body.is_in_group("player"):
		body.run_speed /= 4
		body.walk_speed /= 4
			
		if body.state_machine.state.name == "Dash":
			body.inflict_damage(_specs.attack, true)


func _on_SlowdownArea_body_exited(body):
	if body.is_in_group("player"):
		body.run_speed = body.initial_run_speed
		body.walk_speed = body.initial_walk_speed


func _on_TargetArea_body_exited(body):
	if body.is_in_group("player"):
		is_destination_reached = false


func _on_HurtArea_body_exited(body):
	pass


func _on_WatchArea_body_entered(body):
	if body.is_in_group("player"):
		is_player_detected = true


func _on_WatchArea_body_exited(body):
	if body.is_in_group("player"):
		is_player_detected = false


func _on_Animation_animation_finished(anim_name):
	if anim_name == "die":
		_death_particles.emitting = true
		audio_tween.interpolate_property(_sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		audio_tween.start()
		yield(get_tree().create_timer(1), "timeout")
		die()


func _on_AudioTween_tween_completed(object, key):
	_hurt_audio.stop()
