extends ParallaxBackground

var tween

func reload_colors():
	for node in get_children():
		if node extends Node2D:
			for other_node in node.get_children():
				if other_node extends Tween:
					tween = other_node
			for again_other_node in node.get_children():
				if not again_other_node extends Tween:
					again_other_node.set_modulate(Color(rand_range(0.1, 0.6),rand_range(0.1, 0.6),rand_range(0.1, 0.6),1))
					tween.interpolate_property(again_other_node, "visibility/opacity", 1, 0.5, rand_range(2, 5), 0, 0)
					tween.start()