extends ParallaxBackground

const bar_class = preload("res://scenes/backgrounds/background_bar.tscn")

func _ready():
	for i in range(80):
		var bar = bar_class.instance()
		bar.set_modulate(Color(rand_range(0.1, 0.6),rand_range(0.1, 0.6),rand_range(0.1, 0.6)))
		bar.set_pos(Vector2(16*i, 0))
		add_child(bar)
		bar.get_node("Tween").interpolate_property(bar, "visibility/opacity", 1, 0.5, rand_range(2, 5), 0, 0)
		bar.get_node("Tween").start()