extends ParallaxBackground

func reload_colors():
	for node in $Sprites.get_children():
		node.set_modulate( Color(rand_range(0, 1),rand_range(0, 1),rand_range(0, 1), 0.5 ) )
