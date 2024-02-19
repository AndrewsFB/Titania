extends PlayerState

func enter(_msg := {}) -> void:
	actor.animation.play("fall")

func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if Global.cancel_player_input or Global.is_playing_cutscene:
		return
	
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if(direction != 0) :
		actor.velocity.x = actor.run_speed * direction
	else:
		actor.velocity.x = 1 if actor.facing_right else -1
	
	if Input.is_action_just_pressed("dash") and Input.is_action_pressed("down") and actor.can_dash:
		state_machine.transition_to("Dive")
	elif Input.is_action_just_pressed("dash") and actor.can_dash:
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("jump") and actor.can_jump:
		state_machine.transition_to("ExtraJump")
	elif actor.is_on_floor():
		state_machine.transition_to("Idle")
	
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack3")
