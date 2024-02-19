extends Node2D

var time_bar_initial_width := 0
var _message := ""

onready var time_bar =$Panel/TimeBar
onready var label = $Panel/Label
onready var tween = $Tween


func _ready():
	time_bar_initial_width = time_bar.rect_size.x
	label.text = _message
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _physics_process(delta):
	if self.modulate.a == 1:
		time_bar.rect_size.x = lerp(time_bar.rect_size.x, 0, 0.02)
		if(round(time_bar.rect_size.x) == 0):
			queue_free()


func start(message):
	_message = message

