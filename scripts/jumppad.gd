extends StaticBody2D

export var x = 0
export var y = -1500
export var current_dir = 0

func active_jumppad(body):
	if body.get_name() == "Player":
		body.is_grounded = false
		body.on_jumppad = true
		### with that, X is reset on each activation
		var X = x
		if X == 0:
			X = body.get_linear_velocity().x
		body.set_linear_velocity(Vector2(X, y))
		if current_dir != 0:
			body.current_dir = current_dir
		body.get_node("AnimationPlayer").get_animation("jumppad").track_set_key_value(1, 0, 180*body.current_dir)
		body.get_node("AnimationPlayer").get_animation("jumppad").track_set_key_value(3, 0, -180*body.current_dir)
		body.get_node("AnimationPlayer").play("jumppad")
		if global.sound:
			get_node("SamplePlayer2D").play("jumppad")
