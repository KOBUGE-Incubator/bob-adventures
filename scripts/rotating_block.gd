extends StaticBody2D

export var speed = 1.00
export var size = 1.0
var shape2

func _ready():
	get_node("AnimationPlayer").set_speed(speed)
	get_node("Sprite").set_modulate(Color(rand_range(0.4, 0.6), rand_range(0.4, 0.6), rand_range(0.4, 0.6)))
	get_node("Sprite").set_scale(get_node("Sprite").get_scale()*size)
	shape2 = get_node("CollisionShape2D").get_shape().duplicate()
	shape2.set_extents(shape2.get_extents()*size)
	get_node("CollisionShape2D").set_shape(shape2)
	get_node("AnimationPlayer").play("idle")