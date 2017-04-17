extends Node2D

var loading_level = false
var current_level
onready var player = root.get_node("Player")
onready var level_load_tween = root.get_node("level_load")

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
		level_load_tween.enter()
		loading_level = false
	else:
		print(str("level_",str(global.level), " doesn't exist"))
		load_menu()

func load_menu(level=null):
	global.level = 1
	root.add_child(load("res://scenes/main_menu.tscn").instance())
	queue_free()

func next_level(param="level"):
	if not loading_level:
		global.level += 1
		level_load_tween.quit()
		level_load_tween.connect("animation_ended", self, str("load_",param), [global.level], 4)