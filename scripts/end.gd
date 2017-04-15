extends Area2D

func _ready():
	for sprite in get_node("Sprites").get_children():
		sprite.set_modulate(Color(rand_range(0.3, 0.7),rand_range(0.3, 0.7),rand_range(0.3, 0.7),0.5))

func _on_body_enter(body):
	if body.get_name() == "Player":
		get_node("../../").next_level()