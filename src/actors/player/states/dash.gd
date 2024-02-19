extends PlayerState

onready var cooldown = $Cooldown
onready var duration = $Duration
onready var dust = $Dust


func enter(_msg := {}) -> void:
	if actor.can_dash and cooldown.is_stopped():
		actor.apply_gravity = false
		actor.velocity.x += actor.dash_force * (1 if actor.facing_right else -1)
		actor.can_dash = false
		actor.animation.play("dash")
		actor.velocity.y = 0
		if actor.is_on_floor():
			dust.direction = Vector2(-1 if actor.facing_right else 1, 0)
			dust.emitting = true
		duration.start()
		var ether_explosion = load(Paths.UTIL_ETHER_EXPLOSION).instance()
		ether_explosion.init(actor)


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func exit() -> void:
	dust.emitting = false
	cooldown.start()
	actor.apply_gravity = true


func physics_update(_delta: float) -> void:
	if Global.cancel_player_input or Global.is_playing_cutscene:
		return
		
	actor.create_ghost_trail()
	dust.position = actor.position + Vector2(4, 12)
	
	if actor.velocity.x == 0.0:
		#player.apply_gravity = true
		if actor.is_on_floor():
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Air")


	if Input.is_action_just_released("dash") or duration.is_stopped():
		#player.apply_gravity = true
		actor.velocity.x = 0.0
