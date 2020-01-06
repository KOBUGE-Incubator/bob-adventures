extends Timer

func _on_Timer_timeout():
	global.tmpTime += 1
	get_node("../Label").set_text( str( global.tmpTime/600 ) + ":" + str( (global.tmpTime/10) % 60 ) + ":" + str( global.tmpTime % 10 ) )