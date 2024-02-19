extends CanvasLayer

onready var tween = $Tween
onready var black_screen = $BlackScreen

export var fade_in_speed := 1.5
export var fade_out_speed := 1.5


func _ready():
	fade_in()


func fade_in():
	tween.interpolate_property(black_screen, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), fade_in_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()


func fade_out():
	tween.interpolate_property(black_screen, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), fade_out_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()	
