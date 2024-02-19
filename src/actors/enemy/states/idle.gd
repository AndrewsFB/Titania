extends EnemyState

func enter(_msg := {}) -> void:
	actor.play_animation("idle")


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if actor.is_player_detected:
		state_machine.transition_to("Walk")
