extends EnemyState

func enter(_msg := {}) -> void:
	actor.play_animation("walk")


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if(actor.velocity != Vector2.ZERO):
		actor.last_velocity = actor.velocity
	
	if(actor.last_velocity.x != 0):
		actor.facing_right = actor.last_velocity.x >= 0
	
	actor.flip_h = not actor.facing_right

	if actor.is_player_detected and not actor.is_destination_reached:
		match actor.move_type:
			1:
				_persuit_walker(actor.get_player_pos())
			2:
				_persuit_flyier(actor.get_player_pos())
	
	if actor.is_destination_reached:
		state_machine.transition_to("Attack")


func _persuit_walker(target_position) -> void:
	actor.velocity = (target_position - actor.pos).normalized()
	actor.velocity *= actor.speed


func _persuit_flyier(target_position) -> void:
	actor.velocity.x = (target_position - actor.pos).normalized().x
	actor.velocity.y = 0.0
	actor.velocity *= actor.speed
