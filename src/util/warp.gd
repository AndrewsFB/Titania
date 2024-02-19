extends Area2D


export(NodePath) var destiny
export(NodePath) var player

var is_ready: = false


func _physics_process(delta):
	if Input.is_action_just_pressed("up") and is_ready:
		var player_node = get_node(player)
		player_node.warp_to_position(get_node(destiny).global_position)

func _on_body_entered(body):
	if body.is_in_group("player"):
		is_ready = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		is_ready = false
