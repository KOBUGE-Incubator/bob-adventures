extends Node2D

export var random_color = false
var opened = false

func _ready():
	if random_color:
		var color = Color(rand_range(0.3, 0.5), rand_range(0.3, 0.5), rand_range(0.3, 0.5))
		get_node("bar1/Sprite").set_modulate(color)
		get_node("bar2/Sprite").set_modulate(color)

func open(body=null):
	if not opened:
		opened = true
		get_node("AnimationPlayer").play("open")

func close(body=null):
	if opened:
		opened = false
		get_node("AnimationPlayer").play("close")