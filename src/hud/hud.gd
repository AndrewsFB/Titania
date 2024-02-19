extends CanvasLayer


var thought_node = load(Paths.HUD_THOUGHT_BOX)

onready var hp_green = $HUDBackground/HPGreen
onready var hp_particles = $HUDBackground/HPGreen/Particles
onready var hp_red = $HUDBackground/HPRed
onready var tween_hp = $TweenHP


func _ready():
	pass


func make_thought(text):
	var thought = thought_node.instance()
	thought.start(text)
	add_child(thought)


func _on_Player_hp_change(max_hp, old_value, new_value):
	var hp_perc = (100.0 * new_value / max_hp) / 100
	tween_hp.interpolate_property(hp_green, "rect_scale", hp_green.rect_scale, Vector2(hp_perc, hp_green.rect_scale.y), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if old_value < new_value:
		hp_green.self_modulate = Color(2, 2, 2, 1)
	else:
		hp_red.self_modulate = Color(2, 2, 2, 1)
	tween_hp.start()
	hp_particles.emitting = true


func _on_TweenHP_tween_all_completed():
	hp_green.self_modulate = Color(1, 1, 1, 1)
	hp_red.self_modulate = Color(1, 1, 1, 1)
	hp_particles.emitting = false
