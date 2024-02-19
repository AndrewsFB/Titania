extends PlayerState


func enter(_msg := {}) -> void:
	actor.animation.play("hurt")
	actor.blood.emitting = true


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	actor.velocity = Vector2.ZERO


func _on_Animation_animation_finished(anim_name):
	if anim_name == "hurt":
		actor.state_machine.transition_to("Idle")
