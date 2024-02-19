class_name Crusher
extends WorldObject

onready var core = $Core
onready var sprite = $Sprite
onready var blood = $Sprite/Blood
onready var animation = $Animation
onready var specs = $Specs
onready var death_particles = $DeathParticles
onready var hurt_audio = $HurtAudio
onready var player = owner.get_node("Player")


func _ready():
	core.init(self, specs, player, sprite, animation, blood, death_particles, hurt_audio)


func inflict_damage(damage):
	core.inflict_damage(damage)
	hurt_audio.stop()
