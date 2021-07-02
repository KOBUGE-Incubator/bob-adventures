extends Area2D

func shot( to ):
	$Particles2D.emitting = true
	$Tween.interpolate_property( self, "position", position, position + to, 0.25, 1, 1)
	$Tween.start()
	$Timer.start()
	$Timer.connect( "timeout", self, "queue_free" )

func _on_body_enter( body ):
	if body.is_in_group("killable"):
		body.queue_free()
