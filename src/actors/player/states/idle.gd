extends PlayerState

func enter(_msg := {}) -> void:
	actor.can_jump = true
	actor.can_dash = true
	actor.animation.play("idle")
	actor.velocity = Vector2.ZERO


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if Global.cancel_player_input or Global.is_playing_cutscene:
		return
	
	if not actor.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	var abs_move = abs(Input.get_action_strength("move_left")) + abs(Input.get_action_strength("move_right"))
	
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
	elif Input.is_action_just_pressed("dash") and Input.is_action_pressed("up") and actor.can_dash and actor.can_jump:
		state_machine.transition_to("SuperJump")
	elif(Input.is_action_just_pressed("dash") and actor.can_dash):
		state_machine.transition_to("Dash")		
	elif Input.is_action_just_pressed("jump") and actor.can_jump:
		state_machine.transition_to("Jump")
	elif abs_move > 0:
		state_machine.transition_to("Run")		
