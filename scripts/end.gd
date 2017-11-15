extends Area2D

func _ready():
	get_node("Particles2D").get_color_ramp().set_color(0, Color(rand_range(0.5, 1), rand_range(0.5, 1), rand_range(0.5, 1)))
	get_node("Particles2D").get_color_ramp().set_color(1, Color(rand_range(0.5, 1), rand_range(0.5, 1), rand_range(0.5, 1), 0))

func _on_body_enter(body):
	if body.get_name() == "Player":
		root.get_node("World").next_level()
		root.get_node("World").loading_level = true