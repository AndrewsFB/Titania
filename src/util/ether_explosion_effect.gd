class_name EtherExplosionEffect
extends CPUParticles2D

var ready := false

onready var audio = $Audio


func init(actor):
	ready = true
	global_position = actor.global_position
	actor.owner.add_child(self)
	emitting = true
	audio.play()


func _physics_process(delta):
	if not emitting and ready:
		queue_free()
