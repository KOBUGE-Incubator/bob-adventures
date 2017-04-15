extends ParallaxBackground

func _ready():
	for node in get_children():
		if node.get_name() != "AnimationPlayer":
			node.set_modulate(Color(rand_range(0, 1),rand_range(0, 1),rand_range(0, 1), 0.5))