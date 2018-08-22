extends StaticBody2D

export var x = 0
export var y = -1500
export var override = false

func active_jumppad(body):
	if body.get_name() == "Player":
		body.is_grounded = false
		body.on_jumppad = true
		body.was_on_jumppad = true
		body.shot = false
### with that, X is reset on each activation
		var X = x
		if X == 0 and not override:
			X = body.get_linear_velocity().x
		if override:
			body.set_dir(sign(X))
			body.jump_particles(Vector2(28*(-sign(X)), 0))
		body.set_linear_velocity(Vector2(X, y))
		body.get_node("AnimationPlayer").play("jumppad")
		body.walking.set_speed(body.before_dir*1.5)
		get_node("Particles2D").set_color(Color(rand_range(0.4, 0.8), rand_range(0.4, 0.8), rand_range(0.4, 0.8)))
		get_node("Particles2D").set_emitting(true)
		if global.sound:
			get_node("SamplePlayer2D").play("jumppad")