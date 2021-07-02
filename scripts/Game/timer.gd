extends CanvasLayer

func start():
	$Timer.start()

func stop():
	$Timer.stop()

func _on_Timer_timeout():
	global.tmpTime += 1
	$Label.set_text( str( global.tmpTime/600 ) + ":" + str( (global.tmpTime/10) % 60 ) + ":" + str( global.tmpTime % 10 ) )
