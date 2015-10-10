# player.gd -> living_object.gd -> RigidBody2D
extends "living_object.gd"

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed( "jump" ):
		jump()
	if Input.is_action_pressed( "left" ):
		walk(LEFT)
	if Input.is_action_pressed( "right" ):
		walk(RIGHT)


