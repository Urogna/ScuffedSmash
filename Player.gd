extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const run_speed = 160
const walk_speed = 60
const air_acc = 700
const max_air_speed = 4
const gravity = 700
const jump = 270
const d_jump = 250
const movement = Vector3()
const friction = 15
const crouch_friction = 7
const jump_lock_frames = 3
var jump_lock_frames_counter = 0
var can_d_jump = false
var just_jumped = true

onready var anim = get_node("PlayerAnimations")

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_degrees.y = 90
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_on_floor():
		floor_movement(delta)
	else:
		air_movement(delta)
	
	if jump_lock_frames_counter < jump_lock_frames:
		jump_lock_frames_counter += 1
	
	jump(delta)
	
	move_and_slide(movement, Vector3.UP)
	
	if Input.is_action_pressed("ui_page_up"):
		transform.origin = Vector3(0,0,0)

func jump(delta):
	if Input.is_action_just_pressed("jump"):
		if not is_on_floor() and can_d_jump and jump_lock_frames_counter >= jump_lock_frames:
			double_jump(delta)
		elif is_on_floor():
			movement.y = jump
			just_jumped = true
			jump_lock_frames_counter = 0
			anim.play("Jump")
	elif Input.is_action_just_released("jump") and jump_lock_frames_counter < jump_lock_frames:
		movement.y -= 100

func double_jump(delta):
	if Input.is_action_pressed("ui_right"):
		movement.x += run_speed
	elif Input.is_action_pressed("ui_left"):
		movement.x -= run_speed
	movement.y = d_jump
	can_d_jump = false
	anim.play("Jump")
		
func floor_movement(delta):
	movement.y = -1
	can_d_jump = true
	if Input.is_action_pressed("ui_right"):
		movement.x = run_speed
		rotation_degrees.y = 90
		anim.play("Running")
	elif Input.is_action_pressed("ui_left"):
		movement.x = -run_speed
		rotation_degrees.y = -90
		anim.play("Running")
	elif Input.is_action_pressed("ui_down"):
		if movement.x > crouch_friction:
			movement.x -= crouch_friction
		elif movement.x < -crouch_friction:
			movement.x += crouch_friction
		else:
			movement.x = 0
		anim.play("Crouching")
	else:
		if movement.x > friction:
			movement.x -= friction
		elif movement.x < -friction:
			movement.x += friction
		else:
			movement.x = 0
		anim.play("Idle")
		
func air_movement(delta):
	movement.y -= gravity * delta
	var temp_x = air_acc * delta
	if Input.is_action_pressed("ui_right"):
		if movement.x < run_speed:
			movement.x += temp_x
		else:
			movement.x = run_speed
	elif Input.is_action_pressed("ui_left"):
		if movement.x > -run_speed:
			movement.x -= temp_x
		else:
			movement.x = -run_speed
