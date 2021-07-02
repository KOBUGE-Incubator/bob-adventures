extends Area2D


func _on_body_enter(body):
	if body.get_name() == "Player":
		root.world.next_level()
		root.world.loading_level = true
