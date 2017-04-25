extends Node2D

var loading_level = false
var current_level
onready var player = root.get_node("Player")
onready var level_load_anim = root.get_node("level_load/AnimationPlayer")

func _ready():
	load_level(global.level)

func load_level(level_number):
	var level_load = load(str("res://scenes/levels/level_", str(level_number), ".tscn"))
	if level_load != null:
		for child in get_children():
			if child extends TileMap:
				child.queue_free()
		current_level = level_number
		global.level = current_level
		var level_loaded = level_load.instance()
		add_child(level_loaded)
		get_node("Background").reload_colors()
		player.spawn = level_loaded.get_node("spawn").get_pos()
		player.limit = level_loaded.get_node("limit").get_pos().y
		player.respawn()
		loading_level = false
	else:
		print(str("level_",str(global.level), " doesn't exist"))
		load_menu()

func load_menu(level=null):
	global.level = 1
	root.add_child(load("res://scenes/main_menu.tscn").instance())
	queue_free()

func preload_level(param, level=null):
	if not loading_level:
		player.respawned = false
		player.go_to_dir(0, true)
		level_load_anim.play("exit")
		level_load_anim.connect("finished", self, str("load_",param), [level], 4)

func next_level():
	if not loading_level:
		global.level += 1
		preload_level("level", global.level)