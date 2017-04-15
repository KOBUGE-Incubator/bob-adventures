extends Node2D

var level = 1

func _ready():
	load_level(level)
#	current_level.instance()
#	add_child(current_level)
	set_process_input(true)

func load_level(level_number):
	var level_load = load(str("res://scenes/levels/level_", str(level), ".tscn"))
	if level_load != null:
		for child in get_children():
			if child.get_name().begins_with("level"):
				child.queue_free()
		add_child(level_load.instance())
	else:
		print(str("level level_",str(level), " doesn't exist"))

func next_level():
	level += 1
	load_level(level)