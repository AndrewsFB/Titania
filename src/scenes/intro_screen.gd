extends Node2D

onready var screen = $Screen
onready var text = $Screen/Text
onready var author_sign = $Screen/AuthorSign
onready var tween_text = $TweenText
onready var tween_author = $TweenSign
onready var tween_out = $TweenOut


func _ready():
	text.modulate = Color(1, 1, 1, 0)
	author_sign.modulate = Color(1, 1, 1, 0)
	#yield(get_tree().create_timer(5, true), "timeout")
	owner.get_node("AudioStreamPlayer").play()
	tween_text.interpolate_property(text, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween_text.start()


func _on_TweenText_tween_completed(object, key):
	tween_author.interpolate_property(author_sign, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween_author.start()


func _on_TweenSign_tween_completed(object, key):
	tween_out.interpolate_property(screen, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween_out.start()
	


func _on_TweenOut_tween_completed(object, key):
	var tree = get_tree()
	var game = tree.get_root()
	game.remove_child(self)
	self.call_deferred("free")
	var first_scene = load(Paths.SCENE_MOUNTAIN_PEAK).instance()
	game.add_child(first_scene)
