extends PlayerState

func enter(_msg := {}) -> void:
	actor.velocity.y += actor.jump_force
	actor.animation.play("jump")


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if Global.cancel_player_input or Global.is_playing_cutscene:
		return
		
	if actor.velocity.y > 0.0 and not actor.is_on_floor():
		state_machine.transition_to("Air")
	elif actor.is_on_floor():
		state_machine.transition_to("Idle")
		
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if(direction != 0):
		actor.velocity.x = actor.run_speed * direction
	
	if Input.is_action_just_pressed("roll") and Input.is_action_pressed("down"):
		state_machine.transition_to("Dive")
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	
	if Input.is_action_just_released("jump") and actor.can_jump:
		actor.velocity.y = 0.0
	
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack3")
