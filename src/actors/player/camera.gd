extends Camera2D

# The starting range of possible offsets using random values
export var RANDOM_SHAKE_STRENGTH: float = 30.0
# Multiplier for lerping the shake strength to zero
export var SHAKE_DECAY_RATE: float = 5.0

onready var camera = $camera
onready var rand = RandomNumberGenerator.new()
onready var apply_button = $ui/apply_shake

var shake_strength: float = 0.0

var initial_offset := Vector2.ZERO

func _ready() -> void:
	rand.randomize()
	initial_offset = offset


func apply_shake() -> void:
	shake_strength = RANDOM_SHAKE_STRENGTH


func _process(delta: float) -> void:
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, 0, SHAKE_DECAY_RATE * delta)

	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	offset = get_random_offset()


func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength) + initial_offset.x,
		rand.randf_range(-shake_strength, shake_strength) + initial_offset.y
	)
