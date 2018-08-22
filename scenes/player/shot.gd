extends Area2D

func shot(to):
	get_node("Particles2D").set_emitting(true)
	get_node("Tween").interpolate_property(self, "transform/pos", get_pos(), get_pos()+to, 0.25, 1, 1)
	get_node("Tween").start()
	get_node("Timer").start()
	yield(get_node("Timer"), "timeout")
	queue_free()

func _on_body_enter(body):
	if body.is_in_group("killable"):
		body.queue_free()