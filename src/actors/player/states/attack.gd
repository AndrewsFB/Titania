extends PlayerState

var attack_button_released := false
var do_second_attack := false

onready var audio = $Audio


func enter(_msg := {}) -> void:
	actor.velocity = Vector2.ZERO
	attack_button_released = false
	do_second_attack = false
	actor.animation.play("attack_1")
	audio.play()


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	if Global.cancel_player_input or Global.is_playing_cutscene:
		return
	
	if Input.is_action_just_released("attack"):
		attack_button_released = true
	
	if Input.is_action_just_pressed("attack") and attack_button_released:
		do_second_attack = true


func physics_update(_delta: float) -> void:
	pass


func _on_Animation_animation_finished(anim_name):
	if anim_name == "attack_1":
		if do_second_attack:
			state_machine.transition_to("Attack2")
		else:
			state_machine.transition_to("Idle")


func _on_HurtArea_body_entered(body):
	if body.is_in_group("enemy"):
		body.inflict_damage(10)
