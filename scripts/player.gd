# player.gd -> living_object.gd -> RigidBody2D
extends RigidBody2D#"living_object.gd"

var ground_rays
var local_ground_position = Vector2(0, 0)
var time = 0.0
var jump_cooldown_time = 0.0
var last_jump_side = -1

export var jump_speed = 100.0
export var wall_jump_speed = 600.0
export var same_wall_jump_speed = 600.0
export var walk_speed = 10.0
export var air_speed = 10.0
export var jump_cooldown = 0.1
export var side_rays = [NodePath("left_ray"), NodePath("right_ray")]
export var side_directions = Vector2Array([Vector2(0.5, -1), Vector2(-0.5, -1)])

func _ready():
	print(jump_speed)

	ground_rays = get_node("ground_rays").get_children()
	for ray in ground_rays:
		ray.add_exception(self)
	
	for i in range(side_rays.size()):
		side_rays[i] = get_node(side_rays[i])
		side_rays[i].add_exception(self)
	
	
	set_fixed_process(true)

func _fixed_process(delta):
	var is_grounded = false
	for ray in ground_rays:
		if ray.is_colliding() and ray.get_collider():
			is_grounded = true
			break
	
	# Jumping
	if is_grounded:
		last_jump_side = -1
	if Input.is_action_pressed( "jump" ) and jump_cooldown_time < time:
		if is_grounded:
			jump_cooldown_time = time + jump_cooldown
			apply_impulse( local_ground_position, Vector2(0, -jump_speed) )
		else:
			var wall_jump = false
			for i in range(side_rays.size()):
				var ray = side_rays[i]
				var direction = side_directions[i]
				if ray.is_colliding() and ray.get_collider():
					jump_cooldown_time = time + jump_cooldown
					wall_jump = true
					if last_jump_side == i:
						apply_impulse( ray.get_collision_point(), direction * same_wall_jump_speed )
					else:
						apply_impulse( ray.get_collision_point(), direction * wall_jump_speed )
					last_jump_side = i
					break
	
	# Walk/Airwalk-ing
	var walk_vector = Vector2(0 , 0)
	if Input.is_action_pressed( "right" ):
		walk_vector.x += 1
	if Input.is_action_pressed( "left" ):
		walk_vector.x -= 1
	
	if is_grounded:
		walk_vector -= walk_vector * clamp( get_linear_velocity().dot(walk_vector * walk_speed), -1, 0) * 2
		apply_impulse( Vector2(0, 0), walk_vector * walk_speed )
	else:
		walk_vector -= walk_vector * clamp( get_linear_velocity().dot(walk_vector * air_speed), -1, 0) * 2
		apply_impulse( Vector2(0, 0), walk_vector * air_speed )
	
	time += delta

