extends Node2D

onready var animation1 = get_node("event_zone/AnimationPlayer").get_animation("idle").duplicate()
onready var animation2 = get_node("event_zone1/AnimationPlayer").get_animation("idle").duplicate()

onready var animator1 = get_node("event_zone/AnimationPlayer")
onready var animator2 = get_node("event_zone1/AnimationPlayer")

onready var music_button = get_node("CanvasLayer/Control/VBoxContainer/music")
onready var sound_button = get_node("CanvasLayer/Control/VBoxContainer/sound")

var respawned = false
var starting = false
var menu_shown = false


func init():
	respawned = true


func _ready():
	global.launch()
	root.timer.get_node( "Label" ).set_text( str( global.config[ "bestTime" ] / 600 ) + ":" \
											+ str( ( global.config[ "bestTime" ] / 10 ) % 60 ) + ":" \
											+ str( global.config[ "bestTime" ] % 10 ) )
	
	if global.config[ "music" ]:
		music_button.set_pressed( true )
		if not root.music.is_playing():
			root.music.play()
	if global.config[ "sound" ]:
		sound_button.set_pressed( true )
	
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
	
	root.player.spawn = get_node("level_menu/spawn").get_position()
	root.player.limit = get_node("level_menu/limit").get_position().y
	root.player.respawn()
	
	root.level_load.play("enter")
	$event_zone.connect("body_exited", self, "hide_menu")
	$event_zone.connect("body_entered", self, "show_menu")
	
	global.level = 1


func show_menu( _object=null ):
	if not menu_shown:
		menu_shown = true
		sound_button.set_disabled(false)
		music_button.set_disabled(false)
		$show_menu.play("show_menu")
		if root.player.is_grounded:
			root.player.go_to_dir( 0, true )



func hide_menu( _object=null ):
	if menu_shown:
		music_button.set_disabled(true)
		sound_button.set_disabled(true)
		menu_shown = false
		$show_menu.play("hide_menu")


func before_start( _object=null ):
	if not starting and respawned:
		starting = true
		root.level_load.play("exit")
		root.level_load.connect( "animation_finished", root, "load_world", [], CONNECT_ONESHOT )

func set_music():
	global.set_config( "music", !global.config[ "music" ] )
	if global.config[ "music" ]:
		root.music.play()
	else:
		root.music.stop()

func set_sound():
	global.set_config( "sound", !global.config[ "sound" ] )
