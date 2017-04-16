extends Node2D

onready var player = get_node("Player")
onready var level_load_tween = get_parent().get_node("level_load")
onready var animation1 = get_node("event_zone/AnimationPlayer").get_animation("idle").duplicate()
onready var animation2 = get_node("event_zone1/AnimationPlayer").get_animation("idle").duplicate()

onready var animator1 = get_node("event_zone/AnimationPlayer")
onready var animator2 = get_node("event_zone1/AnimationPlayer")

onready var music = get_node("../StreamPlayer")
onready var music_button = get_node("CanvasLayer/Control/VBoxContainer/music")

var respawned = false
var starting = false
var menu_shown = false

func _ready():
	if global.music and not music.is_playing():
		music_button.set_pressed(true)
		music.play()
	get_node("Background").reload_colors()
	animation1.track_set_key_value(0, 0, Color(0.5, 1, 0.7, 0.6))
	animation1.track_set_key_value(0, 1, Color(0.5, 1, 0.7, 0.1))
	animation2.track_set_key_value(0, 0, Color(1, 0.6, 0.4, 0.6))
	animation2.track_set_key_value(0, 1, Color(1, 0.6, 0.4, 0.1))
	animator1.remove_animation("idle")
	animator2.remove_animation("idle")
	animator1.add_animation("idle2", animation1)
	animator2.add_animation("idle2", animation2)
	animator1.play("idle2")
	animator2.play("idle2")
	level_load_tween.enter()
	player.spawn = get_node("level_menu/spawn").get_pos()
	player.limit = get_node("level_menu/limit").get_pos().y
	player.respawn()
	get_node("event_zone").connect("body_exit", self, "hide_menu")
	get_node("event_zone").connect("body_enter", self, "show_menu")

func show_menu(object=null):
	if not menu_shown:
		menu_shown = true
		music_button.set_disabled(false)
		get_node("show_menu").play("show_menu")
		player.current_dir = 0
		player.set_linear_velocity(Vector2(0,0))

func hide_menu(object=null):
	if menu_shown:
		music_button.set_disabled(true)
		menu_shown = false
		get_node("show_menu").play("hide_menu")

func start():
	get_parent().add_child(load("res://scenes/world.xscn").instance())
	queue_free()

func before_start(object=null):
	if not starting and respawned:
		starting = true
		level_load_tween.quit()
		level_load_tween.connect("animation_ended", self, "start", Array(), 4)

func init():
	respawned = true

func set_music():
	global.music = !global.music
	if global.music:
		music.play()
	else:
		music.stop()