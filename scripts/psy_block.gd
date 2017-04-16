extends StaticBody2D

func _ready():
	for node in get_children():
		if node extends Sprite:
			node.set_modulate(Color(rand_range(0,1),rand_range(0,1),rand_range(0,1)))