extends PlayerState

var attack_button_hits := 0

onready var audio = $Audio


func enter(_msg := {}) -> void:
	actor.velocity = Vector2.ZERO
	attack_button_hits = 0
	actor.animation.play("attack_3")
	audio.play()


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if not actor.is_on_floor():
		var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		
		if(direction != 0) :
			actor.velocity.x = actor.run_speed * direction
		else:
			actor.velocity.x = 1 if actor.facing_right else -1


func _on_Animation_animation_finished(anim_name):
	if anim_name == "attack_3":
		state_machine.transition_to("Idle")


func _on_HurtArea_body_entered(body):
	if body.is_in_group("enemy"):
		body.inflict_damage(30)
