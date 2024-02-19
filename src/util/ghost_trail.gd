extends Sprite

func _ready():
	var tween: = $Tween
	tween.interpolate_property(self, 'modulate', Color(1, 1, 1, 1), Color(1, 1 ,1 ,0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
