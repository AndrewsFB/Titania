extends PlayerState

func enter(_msg := {}) -> void:
	actor.animation.play("run")


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if Global.cancel_player_input or Global.is_playing_cutscene:
		return
	
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if(direction != 0) :
		actor.velocity.x = actor.walk_speed * direction
	else:
		actor.velocity.x = 0.0
	
	if not actor.is_on_floor():
		state_machine.transition_to("Air")
		return

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump = true})
	elif abs(direction) > 0.4:
		state_machine.transition_to("Run")
	elif abs(direction) == 0.0:
		state_machine.transition_to("Idle")
