extends PlayerState

func enter(_msg := {}) -> void:
	actor.velocity.y += actor.super_jump_force
	actor.animation.play("super_jump")
	actor.can_jump = false
	actor.can_dash = false
	var ether_explosion = load(Paths.UTIL_ETHER_EXPLOSION).instance()
	ether_explosion.init(actor)

func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if Global.cancel_player_input or Global.is_playing_cutscene:
		return
		
	_create_ghost_trail()
	
	if actor.velocity.y > 0.0 and not actor.is_on_floor():
		state_machine.transition_to("Air")
	elif actor.is_on_floor():
		state_machine.transition_to("Idle")

func _create_ghost_trail() -> void:
	var ghost_trail = load(Paths.UTIL_GHOST_TRAIL).instance()
	ghost_trail.global_position = actor.sprite.global_position
	ghost_trail.flip_h = actor.sprite.flip_h
	ghost_trail.texture = actor.sprite.texture
	ghost_trail.scale = actor.sprite.scale
	ghost_trail.hframes = actor.sprite.hframes
	ghost_trail.vframes = actor.sprite.vframes
	ghost_trail.frame = actor.sprite.frame
	ghost_trail.z_index = actor.sprite.z_index-1
	get_tree().get_root().add_child(ghost_trail)
