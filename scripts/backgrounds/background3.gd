extends ParallaxBackground

onready var anim = get_node("AnimationPlayer")

func _ready():
	rand_colors()
	idle2()

func rand_colors():
	for node in get_children():
		if node extends Sprite:
			node.set_modulate(Color(rand_range(0.2,0.5),rand_range(0.2,0.5),rand_range(0.2,0.5)))

func idle1():
	get_node("Sprite2").set_modulate(Color(rand_range(0.2,0.5),rand_range(0.2,0.5),rand_range(0.2,0.5)))
	get_node("Sprite3").set_modulate(Color(rand_range(0.2,0.5),rand_range(0.2,0.5),rand_range(0.2,0.5)))
	anim.play("idle1")
	anim.connect("finished", self, "idle2", Array(), 4)

func idle2():
	get_node("Sprite").set_modulate(Color(rand_range(0.2,0.5),rand_range(0.2,0.5),rand_range(0.2,0.5)))
	get_node("Sprite1").set_modulate(Color(rand_range(0.2,0.5),rand_range(0.2,0.5),rand_range(0.2,0.5)))
	anim.play("idle2")
	anim.connect("finished", self, "idle1", Array(), 4)