extends Node2D

const levels_path = "res://scenes/Levels/level_"

var loading_level = false
var current_level = null


func _ready():
	load_level( global.level )
	root.timer.start()



func load_level( level_number ):
	var level_load = load( levels_path + str( level_number ) + ".tscn" )
	if( level_load != null ):
		root.player.active( false )
		for child in $levels.get_children():
			child.queue_free()
			
		current_level = level_number
		global.level = current_level
		
		var level_loaded = level_load.instance()
		$levels.add_child( level_loaded )
		get_node( "Background" ).reload_colors()
		
		root.player.spawn = level_loaded.get_node("spawn").get_position()
		root.player.limit = level_loaded.get_node("limit").get_position().y
		root.player.respawn()
		
		loading_level = false
	else:
		print(str("level_",str(global.level), " doesn't exist"))
		root.load_menu()



func preload_level(param, level=null):
	if not loading_level:
		root.player.respawned = false
		root.level_load.play("exit")
		root.level_load.connect( "animation_finished", self, "anim_load", [ param, level ], CONNECT_ONESHOT)



func anim_load( _anim_name="", type="level", level=null ):
	if( type == "" ):
		root.load_menu()
	else:
		load_level( level )



func next_level():
	if not loading_level:
		global.level += 1
		preload_level( "level", global.level )
