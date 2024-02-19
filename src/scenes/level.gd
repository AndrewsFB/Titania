class_name Level
extends Node2D

onready var transition = $Transition
onready var hud = $HUD
onready var dialogs = $Dialogs


func _ready():
	transition.fade_in()


func change_scene(scene_path):
	# Remove the current level
	var tree = get_tree()
	var game = tree.get_root()
	var level = get_tree().get_nodes_in_group("level")[0]
	game.remove_child(level)
	level.call_deferred("free")

	# Add the next level
	var next_level_resource = load(scene_path)
	var next_level = next_level_resource.instance()
	game.add_child(next_level)
