extends CharacterBody3D


@export_category("Movement")
@export var speed : float = 5
@export var jump_velocity : float = 0
@export var acceleration_curve : Curve
@export var curve_speed : float = 0.6
@export var acceleration_speed : float = 6
@export var deceleration_speed : float = 10

@export_category("Mouse")
@export var mouse_sensitivity : float = 0.35

@onready var head = $Head

var current_acceleration : float = 0
var lock_mouse = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		lock_mouse = not lock_mouse
	if event is InputEventMouseMotion and lock_mouse:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _process(delta):
	var target_mouse_mode = Input.MOUSE_MODE_VISIBLE
	if lock_mouse:
		target_mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	Input.set_mouse_mode(target_mouse_mode)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		current_acceleration += acceleration_speed * delta
		current_acceleration = clamp(current_acceleration, 0, 1)
		var current_speed = speed * acceleration_curve.sample(current_acceleration)
		
		var temp_velocity = Vector2(velocity.x, velocity.z)
		temp_velocity = lerp(temp_velocity, Vector2(direction.x * current_speed, direction.z * current_speed), deceleration_speed * delta)
		velocity.x = temp_velocity.x
		velocity.z = temp_velocity.y
	else:
		var temp_velocity = Vector2(velocity.x, velocity.z)
		temp_velocity = lerp(temp_velocity, Vector2.ZERO, deceleration_speed * delta)
		velocity.x = temp_velocity.x
		velocity.z = temp_velocity.y

	move_and_slide()
