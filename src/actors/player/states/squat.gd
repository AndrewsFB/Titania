extends PlayerState

onready var dust = null
onready var cooldown = $Cooldown
onready var audio = $Audio

func enter(_msg := {}) -> void:
	audio.play()
	actor.animation.play("squat")
	actor.camera.apply_shake()
	dust = $Dust.duplicate()
	actor.add_child(dust)
	dust.emitting = true
	actor.can_jump = false
	actor.can_dash = false
	cooldown.start()


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func _on_Cooldown_timeout():
	if actor.is_on_floor():
		state_machine.transition_to("Idle")
