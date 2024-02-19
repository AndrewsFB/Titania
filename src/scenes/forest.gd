extends Level

onready var camera = $Player/Camera2D
onready var tilemap = $TileMap
onready var background = $Background
onready var entry_point_1 = $EntryPoint1
onready var player = $Player


func _ready():
	set_camera_limits()
	#Global.is_playing_first_cutscene = true
	if Global.is_playing_first_cutscene:
		player.position = entry_point_1.position
		var last_dive_force = player.dive_force
		player.dive_force = 200
		player.state_machine.transition_to("Dive")
		player.dive_force = last_dive_force


func _physics_process(delta):
	if player.can_dash and player.can_jump and Global.is_playing_first_cutscene:
		Global.is_playing_first_cutscene = false
		Global.is_playing_cutscene = false
		dialogs.call_dialog('intro')


func set_camera_limits():
	var map_limits = tilemap.get_used_rect()
	var map_cellsize = tilemap.cell_size
	camera.limit_left = map_limits.position.x * map_cellsize.x
	camera.limit_right = map_limits.end.x * map_cellsize.x
	camera.limit_top = map_limits.position.y * map_cellsize.y
	camera.limit_bottom = map_limits.end.y * map_cellsize.y + 40
