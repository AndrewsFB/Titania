extends EnemyState

func enter(_msg := {}) -> void:
	actor.play_animation("attack")


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	actor.velocity = Vector2.ZERO
	
	if actor.is_player_detected and not actor.is_destination_reached and not actor.animation_is_playing():
		state_machine.transition_to("Walk")
	
	if actor.is_destination_reached:
		state_machine.transition_to("Attack")
