extends RigidBody2D

export var time = 1.0
export var destination = Vector2(0, 0)

func _ready():
	var animplayer = AnimationPlayer.new()
	var anim = Animation.new()
	anim.set_length( time * 2 )
	anim.set_loop( true )
	anim.add_track( 0 )
	anim.track_set_path( 0, "..:transform/pos" )
	anim.track_insert_key( 0, 0.0, position )
	anim.track_insert_key( 0, time, destination )
	animplayer.add_animation( "loop", anim )
	animplayer.play( "loop" )
