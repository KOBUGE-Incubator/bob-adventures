extends Node2D

var current_level
var level = 1
onready var player = get_node("Player")

func _ready():
	load_level(level)

func load_level(level_number):
	var level_load = load(str("res://scenes/levels/level_", str(level_number), ".tscn"))
	if level_load != null:
		for child in get_children():
			if child extends TileMap:
				child.queue_free()
		current_level = level_number
		level = current_level
		var level_loaded = level_load.instance()
		add_child(level_loaded)
		get_node("Background").reload_colors()
		player.spawn = level_loaded.get_node("spawn").get_pos()
		player.limit = level_loaded.get_node("limit").get_pos().y
		player.respawn()
	else:
		print(str("level level_",str(level), " doesn't exist"))
		level = current_level

func next_level():
	level += 1
	load_level(level)