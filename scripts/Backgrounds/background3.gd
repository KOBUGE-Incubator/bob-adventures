extends ParallaxBackground

const bar_class = preload( "res://scenes/Backgrounds/background_bar.tscn" )

func _ready():
	for i in range( 20 ):
		var rand_val = 12 + ( randi() % 80 ) / 4
		var rand_color = Color( rand_range(0.1, 0.6),rand_range(0.1, 0.6),rand_range(0.1, 0.6) )
		for j in range( 3 ):
			var bar = bar_class.instance()
			if ( j and j != 2 ):
				bar.modulate = Color( rand_range(0.1, 0.6),rand_range(0.1, 0.6),rand_range(0.1, 0.6) )
			else:
				bar.modulate = rand_color
			
			bar.position = Vector2( 1280 * j, 36 * i )
			bar.scale = Vector2( 1280, 36 )
			bar.modulate.a = 0.75
			add_child( bar )
			
			bar.get_node("Tween").interpolate_property( bar, "position", Vector2( 1280 * j, 36 * i ), Vector2( 1280 * ( j - 2 ), 36 * i ), rand_val, 0, 0 )
			bar.get_node("Tween").start()
