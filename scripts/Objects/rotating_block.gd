extends StaticBody2D

export var speed = 1.00
export var size = 1.0
var shape2 = null

func _ready():
	$AnimationPlayer.set_speed_scale(speed)
	$Sprite.modulate = Color( rand_range(0.4, 0.6), rand_range(0.4, 0.6), rand_range(0.4, 0.6) )
	$Sprite.scale = $Sprite.scale * size
	
	shape2 = $CollisionShape2D.get_shape().duplicate()
	shape2.set_extents( shape2.get_extents() * size )
	
	$CollisionShape2D.set_shape(shape2)
	$AnimationPlayer.play("idle")
