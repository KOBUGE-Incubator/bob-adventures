extends ParallaxBackground

const bar_class = preload("res://scenes/backgrounds/background_bar.tscn")

func _ready():
	for i in range(20):
		var rand_val = 12+(randi() % 80)/4
		var rand_color = Color(rand_range(0.1, 0.6),rand_range(0.1, 0.6),rand_range(0.1, 0.6))
		for j in range(3):
			var bar = bar_class.instance()
			if (j and j != 2):
				bar.set_modulate(Color(rand_range(0.1, 0.6),rand_range(0.1, 0.6),rand_range(0.1, 0.6)))
			else:
				bar.set_modulate(rand_color)
			bar.set_pos(Vector2(1280*j, 36*i))
			bar.set_scale(Vector2(1280, 36))
			bar.set_opacity(0.75)
			add_child(bar)
			bar.get_node("Tween").interpolate_property(bar, "transform/pos", Vector2(1280*j, 36*i), Vector2(1280*(j-2), 36*i), rand_val, 0, 0)
			bar.get_node("Tween").start()