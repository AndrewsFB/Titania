extends EnemyState

func enter(_msg := {}) -> void:
	actor.prepare_death()
	actor.play_animation("die")
	actor.apply_gravity = true
	actor.disable_slowdown_area()


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	actor.velocity = Vector2.ZERO
