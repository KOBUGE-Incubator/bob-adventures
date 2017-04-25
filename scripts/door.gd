extends Node2D

func open(body=null):
	get_node("AnimationPlayer").play("open")

func close(body=null):
	get_node("AnimationPlayer").play("close")
