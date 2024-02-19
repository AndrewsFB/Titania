class_name Aeros
extends WorldObject

onready var core = $Core
onready var sprite = $Sprite
onready var blood = $Sprite/Blood
onready var animation = $Animation
onready var specs = $Specs
onready var death_particles = $DeathParticles
onready var hurt_audio = $HurtAudio
onready var death_audio = $DeathAudio
onready var player = owner.get_node("Player")

func _ready():
	apply_gravity = false
	core.init(self, specs, player, sprite, animation, blood, death_particles, hurt_audio)


func inflict_damage(damage):
	core.inflict_damage(damage)
