extends Node

const debug = true

const default_config = {
	music = true,
	sound = true,
	fullscreen = false,
	bestTime = 0
}

var config = {}

var level = 1
var tmpTime = 0;


func launch():
	load_config()
	randomize()


func set_config( name, value ):
	config[ name ] = value
	save_config()


func load_config():
	var f = File.new()
	var err = f.open_encrypted_with_pass("res://bobsave.save", File.READ, "Bob")
	
	if !err:
		config = f.get_var()
	
	if config == null:
		config = default_config
	else:
		for option in default_config:
			if !config.has(option):
				config[option] = default_config[option]
	
	f.close()
	print( config )


func save_config():
	var f = File.new()
	var _err = f.open_encrypted_with_pass( "res://bobsave.save", File.WRITE, "Bob" )
	f.store_var( config )
	f.close()
