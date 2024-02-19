class_name EnemyState
extends State

var actor: EnemyCore


func init(enemy) -> void:
	self.actor = enemy as EnemyCore
	assert(enemy != null)
