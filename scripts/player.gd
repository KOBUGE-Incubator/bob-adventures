extends RigidBody2D

const bullet = preload("res://scenes/player/shot.tscn")

#On debug = true:
#F5 : previous_level
#F1 : infinite jumps
var debug_infinite_jump = false
var before_dir = 0

var local_ground_position = Vector2(0, 0)
var current_dir = 0
var is_grounded = false
var on_jumppad = false
var was_on_jumppad = false
var can_move = false
var shot = false

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
		if get_pos().y > limit and respawned:
			root.get_node("World").preload_level("level", global.level)
		
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
			if was_on_jumppad:
				on_jumppad = false
				was_on_jumppad = false
				set_dir(current_dir)
			set_linear_velocity(Vector2(current_dir*walk_speed, get_linear_velocity().y))
		shot = false
	else:
		on_jumppad = false
		### Override velocity to stop on a collision
		if abs(get_linear_velocity().x) < 20:
			set_linear_velocity(Vector2(0, get_linear_velocity().y))
			current_dir = 0
	
	if debug_infinite_jump:
		is_grounded = true
	
	### activate particles on a plane ground (not on ramps)
	if is_grounded: #and colliders == 2:
		get_node("Particles2D").set_emitting(true)
	else:
		get_node("Particles2D").set_emitting(false)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if root.has_node("World"):
			root.get_node("World").preload_level("menu")
		else:
			if root.get_node("Menu").menu_shown:
				root.get_node("Menu").hide_menu()
			else:
				if get_node("../AnimationPlayer").is_playing(): return
				get_node("../AnimationPlayer").play("quit")
				yield(get_node("../AnimationPlayer"), "finished")
				get_tree().quit()
	elif event.is_action_pressed("fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())
	if can_move:
		if event.is_action_pressed("left"):
			go_to_dir(-1)
		elif event.is_action_pressed("right"):
			go_to_dir(1)
		elif event.is_action_pressed("down"):
			if root.has_node("Menu") and root.get_node("Menu").menu_shown:
				root.get_node("Menu").hide_menu()
			go_to_dir(0)
		if event.is_action_pressed("jump"):
			jump()
	
	if global.debug:
		if event.is_action_pressed("debug[next_level]"):
			root.get_node("world").next_level()
		elif event.is_action_released("debug[infinite_jumps]"):
			debug_infinite_jump = !debug_infinite_jump

func respawn():
	get_node("Enter").get_animation("enter").track_set_key_value(1, 0, (360*sign(rand_range(-1, 1))))
	current_dir = 0
	set_linear_velocity(Vector2(0,0))
	get_node("Enter").play("exit")
	get_node("Enter").queue("enter")
	get_node("Enter").connect("finished", self, "set_margin", Array(), 4)
	walking.stop()
	walking.set_speed(0)
	get_node("Sprite").set_rot(0)
	get_node("Sprite1").set_rot(0)
	set_pos(spawn)
	root.get_node("level_load/AnimationPlayer").play("enter")
	can_move = true
	respawned = true

func jump():
	if is_grounded:
		shot = false
		var velocity_add = 0
		if get_linear_velocity().y < 0:
			velocity_add = int(get_linear_velocity().y/3)
		set_linear_velocity(Vector2(get_linear_velocity().x, -jump_speed+velocity_add))
		jump_particles(Vector2(0, 28))
		animation_player.play("jump")
		PlaySound("jump")
	else:
		### If right, go left, if left, go right (wall-jump)
		for i in range(side_rays.size()):
			if side_rays[i].is_colliding() and side_rays[i].get_collider():
				shot = false
				if i == 0:
					current_dir = 1
					set_linear_velocity(Vector2(wall_jump_speed, (-jump_speed)+(get_linear_velocity().y/2)))
				else:
					current_dir = -1
					set_linear_velocity(Vector2(-wall_jump_speed, (-jump_speed)+(get_linear_velocity().y/2)))
				jump_particles(Vector2(28*(-current_dir), 0))
				animation_player.get_animation("walljump").track_set_key_value(3, 0, -4*current_dir)
				animation_player.play("walljump")
				set_dir(current_dir)
				PlaySound("walljump")
				return
		if not shot:
			shot = true
			for i in range(4):
				var bullet_class = bullet.instance()
				bullet_class.set_pos(get_pos())
				get_parent().add_child(bullet_class)
				bullet_class.shot(Vector2(cos(i*PI/2)*384, sin(i*PI/2)*384))

func jump_particles(pos):
	get_node("Impulsion").set_emitting(false)
	get_node("Impulsion").set_pos(pos)
	get_node("Impulsion").set_emitting(true)

func go_to_dir(dir, smooth=false):
	if current_dir == -dir or abs(get_linear_velocity().x) <= air_speed or dir == 0:
		set_dir(dir)
		if not is_grounded and not smooth:
			set_linear_velocity(Vector2(air_speed*dir, get_linear_velocity().y))
	else:
		current_dir = dir

func set_margin():
	get_node("Camera2D").set_drag_margin(0, 0.05)
	get_node("Camera2D").set_drag_margin(1, 0.2)
	get_node("Camera2D").set_drag_margin(2, 0.05)

func set_dir(dir):
	if current_dir != 0:
		before_dir = current_dir
		walking.set_speed(current_dir*0.1)
	if not walking.is_playing():
		walking.play("idle")
	current_dir = dir
	if not dir == 0:
		before_dir = current_dir
		walking.set_speed(current_dir)

func PlaySound(sound):
	if global.config["sound"]:
		get_node("SamplePlayer").play(sound)