# player.gd -> living_object.gd -> RigidBody2D
extends RigidBody2D#"living_object.gd"

#On debug = true:
#F5 : previous_level
#F1 : infinite jumps
var debug_infinite_jump = false
var before_dir = 0

var local_ground_position = Vector2(0, 0)
var current_dir = 0
var is_grounded = false
var on_jumppad = false


const jump_speed = 800
const wall_jump_speed = 600
const walk_speed = 700
const air_speed = 300
var side_rays = [NodePath("arrays/left_ray"),NodePath("arrays/right_ray")]
var ground_rays = [NodePath("arrays/ground"), NodePath("arrays/ground2")]

var spawn
var limit = null
var respawned = false

onready var walking = get_node("Walking")
onready var animation_player = get_node("AnimationPlayer")

func _ready():
	for i in range(ground_rays.size()):
		ground_rays[i] = get_node(ground_rays[i])
		ground_rays[i].add_exception(self)
	
	for i in range(side_rays.size()):
		side_rays[i] = get_node(side_rays[i])
		side_rays[i].add_exception(self)
	
	set_process_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	if limit != null:
		if get_pos().y > limit:
			respawn()
		
	var colliders = 0
	is_grounded = false
	for i in range(ground_rays.size()):
		if ground_rays[i].is_colliding() and ground_rays[i].get_collider():
			if not ground_rays[i].get_collider().get_name().begins_with("jumppad"):
				is_grounded = true
				colliders += 1
	
	# constant velocity on ground
	if is_grounded:
		if not on_jumppad:
			set_linear_velocity(Vector2(current_dir*walk_speed, get_linear_velocity().y))
	else:
		on_jumppad = false
		### Override velocity to stop on a collision
		if abs(get_linear_velocity().x) < 20:
			set_linear_velocity(Vector2(0, get_linear_velocity().y))
			current_dir = 0
	
	if debug_infinite_jump:
		is_grounded = true
	### activate particles on a plane ground (not on ramps)
	if is_grounded and colliders == 2:
		get_node("Particles2D").set_emitting(true)
	else:
		get_node("Particles2D").set_emitting(false)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if root.get_node("World") != null:
			root.get_node("World").next_level("menu")
		else:
			if root.get_node("Menu").menu_shown:
				root.get_node("Menu").hide_menu()
			else:
				get_tree().quit()
	elif event.is_action_pressed("fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())
	
	if event.is_action_pressed("left"):
		go_to_dir(-1)
	elif event.is_action_pressed("right"):
		go_to_dir(1)
	elif event.is_action_pressed("down"):
		go_to_dir(0)
	if event.is_action_pressed("jump"):
		jump()
	
	if global.debug:
		if event.is_action_pressed("debug[next_level]"):
			root.get_node("world").next_level()
		elif event.is_action_released("debug[infinite_jumps]"):
			debug_infinite_jump = !debug_infinite_jump

func respawn():
	current_dir = 0
	set_linear_velocity(Vector2(0,0))
	walking.stop()
	get_node("Sprite").set_scale(Vector2(0.5, 0.5))
	get_node("Sprite1").set_scale(Vector2(0.45, 0.45))
	get_node("Sprite").set_rotd(0)
	get_node("Sprite1").set_rotd(0)
	set_pos(spawn)
	respawned = true

func jump():
	if is_grounded:
		var velocity_add = 0
		if get_linear_velocity().y < 0:
			velocity_add = int(get_linear_velocity().y/3)
		set_linear_velocity(Vector2(get_linear_velocity().x, -jump_speed+velocity_add))
		animation_player.play("jump")
		PlaySound("jump")
	else:
		### If right, go left, if left, go right (wall-jump)
		if side_rays[0].is_colliding() and side_rays[0].get_collider():
			current_dir = 1
			set_linear_velocity(Vector2(wall_jump_speed, (-jump_speed)+(get_linear_velocity().y/2)))
			animation_player.play("walljump")
			set_dir(current_dir)
			PlaySound("walljump")
		if side_rays[1].is_colliding() and side_rays[1].get_collider():
			current_dir = -1
			set_linear_velocity(Vector2(-wall_jump_speed, (-jump_speed)+(get_linear_velocity().y/2)))
			animation_player.play("walljump")
			set_dir(current_dir)
			PlaySound("walljump")

func go_to_dir(dir, smooth=false):
	if current_dir == -dir or abs(get_linear_velocity().x) <= air_speed or dir == 0:
		set_dir(dir)
		if not is_grounded and not smooth:
			set_linear_velocity(Vector2(air_speed*dir, get_linear_velocity().y))
	else:
		current_dir = dir

func set_dir(dir):
	if current_dir != 0:
		before_dir = current_dir
		walking.set_speed(current_dir*0.15)
	if not walking.is_playing():
		walking.play("idle")
	current_dir = dir
	if not dir == 0:
		walking.set_speed(current_dir)

func PlaySound(sound):
	if global.sound:
		get_node("SamplePlayer").play(sound)