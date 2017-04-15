extends Node2D

var current_level
var level = 1
onready var player = get_node("Player")

func _ready():
	load_level(level)

func load_level(level_number):
	var level_load = load(str("res://scenes/levels/level_", str(level), ".tscn"))
	if level_load != null:
		for child in get_children():
			if child.get_name().begins_with("level"):
				child.queue_free()
		add_child(level_load.instance())
		player.spawn = get_node(str("level_",str(level),"/spawn")).get_pos()
		player.limit = get_node(str("level_",str(level),"/limit")).get_pos().y
		player.respawn()
		get_node("Background").reload_colors()
		current_level = level
	else:
		print(str("level level_",str(level), " doesn't exist"))
		level = current_level

func next_level():
	level += 1
	load_level(level)