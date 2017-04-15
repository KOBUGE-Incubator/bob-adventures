# player.gd -> living_object.gd -> RigidBody2D
extends RigidBody2D#"living_object.gd"

var local_ground_position = Vector2(0, 0)
var time = 0.0
var jump_cooldown_time = 0.0
var last_jump_side = -1
var speed_type
var current_dir = 0
var is_grounded = false

const jump_speed = 800
const wall_jump_speed = 500
const walk_speed = 700
const air_speed = 300
const jump_cooldown = 0.2
var side_rays = [NodePath("arrays/left_ray"),NodePath("arrays/right_ray")]
const side_directions = Vector2Array([Vector2(0.5, -1), Vector2(-0.5, -1)])
var ground_rays = [NodePath("arrays/ground"), NodePath("arrays/ground2")]

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
	if get_pos().y > 6000:
		current_dir = 0
		set_pos(Vector2(0,0))
		set_linear_velocity(Vector2(0,0))
	
	var colliders = 0
	is_grounded = false
	for i in range(ground_rays.size()):
		if ground_rays[i].is_colliding() and ground_rays[i].get_collider():
			is_grounded = true
			colliders += 1
	
	# constant velocity on ground
	if is_grounded:
		set_linear_velocity(Vector2(current_dir*walk_speed, get_linear_velocity().y))
	
	if is_grounded and colliders == 2:
		get_node("Particles2D").set_emitting(true)
	else:
		get_node("Particles2D").set_emitting(false)
	
	time += delta

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event.is_action_pressed("fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())
	
	if event.is_action_pressed("left"):
		go_to_dir(-1)
	elif event.is_action_pressed("right"):
		go_to_dir(1)
	elif event.is_action_pressed("down"):
		go_to_dir(0)
	if event.is_action_pressed("jump") and jump_cooldown_time < time:
		jump()

func jump():
	if is_grounded:
		jump_cooldown_time = time + jump_cooldown
		set_linear_velocity(Vector2(get_linear_velocity().x, -jump_speed) )
	else:
		var wall_jump = false
		### If right, go left, if left, go right (wall-jump)
		if side_rays[0].is_colliding() and side_rays[0].get_collider():
			wall_jump = true
			current_dir = 1
			set_linear_velocity(Vector2(wall_jump_speed, (-jump_speed)+(get_linear_velocity().y/2)))
			animation_player.get_animation("jump").track_set_key_value(1, 0, 30)
			animation_player.play("jump")
			jump_cooldown_time = time + jump_cooldown
		if side_rays[1].is_colliding() and side_rays[1].get_collider():
			wall_jump = true
			current_dir = -1
			set_linear_velocity(Vector2(-wall_jump_speed, (-jump_speed)+(get_linear_velocity().y/2)))
			animation_player.get_animation("jump").track_set_key_value(1, 0, -30)
			animation_player.play("jump")
			jump_cooldown_time = time + jump_cooldown

func go_to_dir(dir):
	if current_dir == -dir or abs(get_linear_velocity().x) <= air_speed or dir == 0  and not is_grounded:
		current_dir = dir
		set_linear_velocity(Vector2(air_speed*dir, get_linear_velocity().y))
	else:
		current_dir = dir