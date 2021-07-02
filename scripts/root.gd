extends Node

const world_path = "res://scenes/Game/World.tscn"
const menu_path = "res://scenes/Game/Menu.tscn"
const player_path = "res://scenes/Game/Player.tscn"
const timer_path = "res://scenes/Game/Timer.tscn"


onready var level_load = $level_load/AnimationPlayer
onready var music = $StreamPlayer

var world = null
var menu = null
var player = null
var timer = null


func _ready():
	load_menu()
	set_process_input( true )




func load_game_node( node_name, path ):
	if( not $Game.has_node( node_name ) ):
		var node = load( path ).instance()
		$Game.add_child( node )
		return node
	return  $Game.get_node( node_name )

func clear_game_node( node_name ):
	if( $Game.has_node( node_name ) ):
		$Game.get_node( node_name ).queue_free()




func load_world( _unused1=null, _unused2=null ):
	if( player != null ):
		player.active( false )
	clear_game_node( "Editor" )
	clear_game_node( "Menu" )
	
	timer = load_game_node( "Timer", timer_path )
	player = load_game_node( "Player", player_path )
	world = load_game_node( "World", world_path )
	
	global.tmpTime = 0;
	player.active( true )




func load_menu( _unused1=null, _unused2=null ):
	if( player != null ):
		player.active( false )
	
	clear_game_node( "Editor" )
	clear_game_node( "World" )
	
	timer = load_game_node( "Timer", timer_path )
	player = load_game_node( "Player", player_path )
	menu = load_game_node( "Menu", menu_path )
	
	player.active( true )



func load_editor( _unused1=null, _unused2=null ):
	clear_game_node( "Timer" )
	clear_game_node( "World" )
	clear_game_node( "Player" )
	clear_game_node( "Menu" )



func _input( event ):
	if event.is_action_pressed( "ui_cancel" ):
		if( world != null ):
			load_menu()
		elif( menu != null ):
			if menu.menu_shown:
				menu.hide_menu()
			elif( not $AnimationPlayer.is_playing() ):
				$AnimationPlayer.play( "quit" )
				yield( $AnimationPlayer, "animation_finished" )
				get_tree().quit()
	elif event.is_action_pressed( "fullscreen" ):
		OS.set_window_fullscreen( !OS.is_window_fullscreen() )
	
	if global.debug:
		if( world != null and event.is_action_pressed( "debug[next_level]" ) ):
			world.next_level()
		elif( player != null and event.is_action_released( "debug[infinite_jumps]" ) ):
			player.debug_infinite_jump = !player.debug_infinite_jump

