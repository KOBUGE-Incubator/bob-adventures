extends KinematicBody2D

const bullet = preload("res://scenes/player/shot.tscn")

const GRAVITY = 40

const jump_speed = 1000
const wall_jump_speed = 700
const walljump_factor = 0.6

const walk_speed = 900
const air_speed = 400


#On debug = true:
#F5 : previous_level
#F1 : infinite jumps
var debug_infinite_jump = false
var before_dir = 0

var local_ground_position = Vector2(0, 0)
var current_dir = 0

var is_grounded = false
var on_jumppad = false

var shot = false

var velocity = Vector2()

var left_rays = [ NodePath("rays/left"),NodePath("rays/left2") ]
var right_rays = [ NodePath("rays/right"),NodePath("rays/right2") ]
var ceiling_rays = [ NodePath("rays/top"), NodePath("rays/top2") ]
var ground_rays = [ NodePath("rays/ground"), NodePath("rays/ground2") ]

var spawn
var limit = null
var respawned = false

onready var walking = get_node("Walking")
onready var animation_player = get_node("AnimationPlayer")



func _ready():
	var ray_array = [ left_rays, right_rays, ceiling_rays, ground_rays ]
	
	for i in range( ray_array.size() ):
		for j in range( ray_array[ i ].size() ):
			ray_array[ i ][ j ] = get_node( ray_array[ i ][ j ] )
			ray_array[ i ][ j ].add_exception( self )


func check_rays( array ):
	for ray in array:
		if( ray.is_colliding() ):
			return true
	return false


func active( boolean ):
	set_process_input( boolean )
	set_physics_process( boolean )




func _physics_process( _delta ):
	if limit != null:
		if position.y > limit and respawned:
			if( root.menu != null ):
				respawn()
			elif( root.world != null ):
				root.world.preload_level( "level", global.level )
		
	is_grounded = check_rays( ground_rays )
	
	# constant velocity on ground
	if is_grounded:
		if( velocity.x < walk_speed ):
			velocity.x = walk_speed * current_dir
		if( is_on_floor() and velocity.y > 0 ): #we want the player as close to the floor as possible
			velocity.y = 0
	else:
		### Override velocity to stop on a collision
		if( is_on_wall() ):
			var wall = false
			### Check we're not getting away from the wall
			if( velocity.x < 0 ):
				wall = check_rays( left_rays )
			elif( velocity.x > 0 ):
				wall = check_rays( right_rays )
			
			if( wall ):
				if( not on_jumppad ):
					velocity.x = 0
					current_dir = 0
				on_jumppad = false
		
		if( velocity.y < 0 ):
			if( check_rays( ceiling_rays ) ):
				velocity.y = 0
		
		velocity.y += GRAVITY
	
	if debug_infinite_jump:
		is_grounded = true
	
	### activate particles on a plane ground (not on ramps)
	if is_grounded and current_dir != 0: #and colliders == 2:
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false
	
	velocity.y = move_and_slide( velocity, Vector2( 0, -1 ), false, 4, PI * 0.3 ).y




func _input( event ):
	check_dir( event, "left", -1 )
	check_dir( event, "right", 1 )
	check_dir( event, "down", 0 )

	if event.is_action_pressed( "jump" ):
		jump()




func respawn():
	$Enter.get_animation( "enter" ).track_set_key_value( 1, 0, ( 360 * sign( rand_range( -1, 1 ) ) ) )
	current_dir = 0
	velocity = Vector2( 0, 0 )
	
	$Enter.play( "exit" )
	$Enter.queue( "enter" )
	$Enter.connect( "animation_finished", self, "_set_margin", [], CONNECT_ONESHOT )
	walking.stop()
	walking.set_speed_scale( 0 )
	$Sprite.set_rotation( 0 )
	$Sprite1.set_rotation( 0 )
	position = spawn
	root.get_node( "level_load/AnimationPlayer" ).play( "enter" )
	
	active( true )
	respawned = true




func _set_margin( _anim_name="" ):
	set_margin()




func jump():
	if is_grounded:
		shot = false
		velocity.y = -jump_speed + min( 0, velocity.y / 3 )
		jump_particles( Vector2( 0, 28 ) )
		animation_player.play( "jump" )
		PlaySound( "jump" )
	else:
		### If right, go left, if left, go right (wall-jump)
		if( check_rays( left_rays ) ):
			walljump( 1 )
			return
		elif( check_rays( right_rays ) ):
			walljump( -1 )
			return
		
		if not shot:
			shot = true
			shoot()




func walljump( direction ):
	shot = false
	
	current_dir = direction
	velocity = Vector2( current_dir * wall_jump_speed, velocity.y * walljump_factor - jump_speed )

	jump_particles( Vector2( -current_dir * 28, 0 ) )
	animation_player.get_animation( "walljump" ).track_set_key_value( 3, 0, -4 * current_dir )
	animation_player.play( "walljump" )
	set_dir( current_dir )
	PlaySound( "walljump" )


func shoot():
	for i in range( 4 ):
		var bullet_class = bullet.instance()
		bullet_class.position = position
		get_parent().add_child( bullet_class )
		bullet_class.shot( Vector2( cos( i * PI / 2 ) * 384, sin( i * PI / 2 ) * 384 ) )


func jump_particles( pos ):
	$Impulsion.emitting = false
	$Impulsion.one_shot = false
	$Impulsion.position = pos
	$Impulsion.one_shot = true
	$Impulsion.emitting = true


func go_to_dir( dir, smooth=false ):
	if current_dir == -dir or abs( velocity.x ) <= air_speed or dir == 0:
		set_dir( dir )
		if not is_grounded and not smooth:
			velocity.x = air_speed * dir
		else:
			velocity.x = walk_speed * dir
	else:
		current_dir = dir

func check_dir( event, event_name, dir ):
	if( event.is_action_pressed( event_name ) ):
		go_to_dir( dir )


func set_margin():
	get_node( "Camera2D" ).set_drag_margin( 0, 0.05 )
	get_node( "Camera2D" ).set_drag_margin( 1, 0.2 )
	get_node( "Camera2D" ).set_drag_margin( 2, 0.05 )


func set_dir( dir ):
	if current_dir != 0:
		before_dir = current_dir
		walking.set_speed_scale( current_dir * 0.1 )
	if not walking.is_playing():
		walking.play( "idle" )
	current_dir = dir
	if( not dir == 0 ):
		before_dir = current_dir
		walking.set_speed_scale( current_dir )


func PlaySound( sound ):
	if global.config[ "sound" ]:
		get_node( sound ).play()
