# living_object.gd -> RigidBody2D
extends RigidBody2D

export var force_contacts_monitor = true
export var max_health = 10.0
export var ground_raycast_path = NodePath("ray_down")

export var walk_speed = 100.0
export var jump_speed = 1000.0
export var anti_angle_multiplier = 0.2

export var jump_cooldown = 0.01

var is_grounded = false
var ground_pos = Vector2(0, 0)
var _old_ground_pos
var _old_ground_contacts = 0

var _walk_direction = 0
var _jump = false

var time = 0
var _jump_cooldown_time = 0

const LEFT = -0.6
const RIGHT = 0.6


func _ready():
	if force_contacts_monitor:
		set_contact_monitor( true )
		set_max_contacts_reported( max(get_max_contacts_reported(), 10) )
	
	set_can_sleep( false )
	set_use_custom_integrator( true )

func _integrate_forces(state):
	_old_ground_pos = ground_pos
	ground_pos = Vector2(0, 0)
	var ground_contacts = 0
	for idx in range(state.get_contact_count()):
		if get_shape(state.get_contact_local_shape(idx)) extends RayShape2D:
			ground_pos += state.get_contact_collider_pos( idx )
			ground_contacts += 1
	
	ground_pos = ground_pos / ground_contacts - get_pos()
	if is_grounded and ground_contacts > 0:
		ground_pos = _old_ground_pos.linear_interpolate( ground_pos, 1/(_old_ground_contacts * ground_contacts)*2 )
	_old_ground_contacts = ground_contacts
	
	is_grounded = (ground_contacts > 0)
	

	if _jump and is_grounded:
		apply_impulse( ground_pos * Vector2(-1, 1), Vector2(0, -jump_speed).rotated(get_rot()) )
	
	var walk_vector = Vector2(clamp(_walk_direction, -1, 1) , 0)
	if is_grounded:
		walk_vector = walk_vector.rotated( get_rot() )
		apply_impulse( ground_pos, walk_vector * walk_speed)
	else:
		state.set_linear_velocity( state.get_linear_velocity() + walk_vector * walk_speed )
	
	if not is_grounded:
		var fix_velocity = (get_rot() - state.get_total_gravity().atan2()) * anti_angle_multiplier
		state.set_angular_velocity( state.get_angular_velocity() + fix_velocity )
	
	time += state.get_step()
	_walk_direction = _walk_direction / 2
	_jump = false
	if not is_grounded and _jump_cooldown_time > time:
		_jump_cooldown_time += (time - _jump_cooldown_time)/2
	
	state.integrate_forces()

func walk(direction):
	_walk_direction += direction

func jump():
	if is_grounded and _jump_cooldown_time < time:
		_jump = true
		_jump_cooldown_time = time + jump_cooldown