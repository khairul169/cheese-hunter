extends KinematicBody

# Member variables
var g = -19.6;
var vel = Vector3();
var on_floor = false;
var freeze = true;

const MAX_SPEED = 8;
const JUMP_SPEED = 8;
const ACCEL= 5;
const DEACCEL= 5;
const MAX_SLOPE_ANGLE = 30;

func _ready():
	freeze = true;
	add_to_group("player");
	
	set_process_input(true);
	set_fixed_process(true);

func _input(ie):
	if ie.type == InputEvent.MOUSE_MOTION && !freeze:
		var scr_size = get_viewport().get_rect().size;
		if ie.global_pos.x < scr_size.width/2:
			get_node("spr").set_flip_h(true);
		else:
			get_node("spr").set_flip_h(false);
	
	if ie.type == InputEvent.MOUSE_BUTTON:
		if ie.pressed && ie.button_index == BUTTON_LEFT && on_floor && !freeze:
			vel.y = JUMP_SPEED;

func _fixed_process(delta):
	var dir = Vector3();
	
	if get_node("spr").is_flipped_h():
		dir.x = -1;
	else:
		dir.x = 1;
	
	if freeze:
		dir.x = 0;
	dir.y = 0;
	dir = dir.normalized();
	
	vel.y += delta*g;
	
	var hvel = vel;
	hvel.y = 0;
	
	var target = dir*MAX_SPEED;
	var accel;
	if (dir.dot(hvel) > 0):
		accel = ACCEL;
	else:
		accel = DEACCEL;
	
	hvel = hvel.linear_interpolate(target, accel*delta);
	
	vel.x = hvel.x;
	vel.z = hvel.z;
	
	var motion = move(vel*delta);
	
	on_floor = false;
	var original_vel = vel;
	var floor_velocity = Vector3();
	var attempts = 4;
	
	while(is_colliding() and attempts):
		var n = get_collision_normal();
		
		if (rad2deg(acos(n.dot(Vector3(0, 1, 0)))) < MAX_SLOPE_ANGLE):
				# If angle to the "up" vectors is < angle tolerance,
				# char is on floor
				floor_velocity = get_collider_velocity()
				on_floor = true
			
		motion = n.slide(motion)
		vel = n.slide(vel)
		if (original_vel.dot(vel) > 0):
			# Do not allow to slide towads the opposite direction we were coming from
			motion=move(motion)
			if (motion.length() < 0.001):
				break
		attempts -= 1
	
	if (on_floor and floor_velocity != Vector3()):
		move(floor_velocity*delta)
	
	if on_floor && abs(vel.x) >= 0.1:
		set_animation("run");
		globals.score += 10*delta;
	else:
		set_animation("idle");

func set_animation(ani, force = false):
	var ap = get_node("AnimationPlayer");
	if ap.get_current_animation() != ani || force:
		ap.play(ani);
