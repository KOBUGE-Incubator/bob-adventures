extends Node2D

export var random_color = false
var opened = false

func _ready():
	if random_color:
		var color = Color( rand_range(0.3, 0.5), rand_range(0.3, 0.5), rand_range(0.3, 0.5) )
		get_node("bar1/Sprite").modulate = color
		get_node("bar2/Sprite").modulate = color

func open( _body=null ):
	if not opened:
		opened = true
		$AnimationPlayer.play("open")

func close( _body=null ):
	if opened:
		opened = false
		$AnimationPlayer.play("close")
