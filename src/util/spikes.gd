extends Area2D

export var damage: = 10
var is_ready: = false

func _physics_process(delta):
	pass
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		is_ready = false
		body.inflict_damage(damage)


func _on_body_exited(body):
	if body.is_in_group("player"):
		is_ready = true
