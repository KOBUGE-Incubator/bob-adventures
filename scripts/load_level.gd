extends CanvasLayer

signal animation_ended()

onready var tween = get_node("Tween")

func enter():
	for node in get_children():
		if node extends Sprite:
			get_node("Tween").interpolate_property(node, "offset", Vector2(-0.5,0), Vector2(-1,0), 1, randi()%11, randi()%4)
			get_node("Tween").start()

func quit():
	for node in get_children():
		if node extends Sprite:
			get_node("Tween").interpolate_property(node, "offset", Vector2(-1,0), Vector2(-0.5,0), 1, randi()%11, randi()%4)
			get_node("Tween").start()

func emit_signal_end(object, string):
	emit_signal("animation_ended")
