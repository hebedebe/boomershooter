class_name Player
extends CharacterBody3D

signal on_hit(source_path: NodePath)
signal on_parried(source_path: NodePath)

@export_category("Movement")
@export var gravity : Vector3 = Vector3(0,-20,0)
@export var speed : float = 5
@export var jump_velocity : float = 0
@export var acceleration_curve : Curve
@export var curve_speed : float = 0.6
@export var acceleration_speed : float = 6
@export var deceleration_speed : float = 10

@export_category("Mouse")
@export var mouse_sensitivity : float = 0.35

@onready var neck = $Neck
@onready var footsteps: AudioStreamPlayer3D = $Footsteps
@onready var jump: AudioStreamPlayer3D = $Jump
@onready var camera: PlayerCamera = $Neck/Camera
@onready var attack_state_controller: StateController = $AttackStateController
@onready var hurt_sound: AudioStreamPlayer = $Hurt
@onready var dash_cooldown: Timer = $DashCooldown
@onready var dash_sound: AudioStreamPlayer = $DashSound


var network_manager: NetworkManager
var current_acceleration : float = 0
var lock_mouse = true
var username: String
var active: bool = true

func _ready():
	network_manager = get_tree().get_first_node_in_group("network_manager")

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if not is_multiplayer_authority() or not active: return
	
	if Input.is_action_just_pressed("ui_cancel"):
		lock_mouse = not lock_mouse
	if event is InputEventMouseMotion and lock_mouse:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		neck.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _process(_delta):
	if not active: return
	
	var should_footsteps_play = velocity.length_squared() > 10 and is_on_floor()
	if should_footsteps_play != footsteps.playing:
		footsteps.playing = should_footsteps_play
	
	if not is_multiplayer_authority(): return
	
	var target_mouse_mode = Input.MOUSE_MODE_VISIBLE
	if lock_mouse:
		target_mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	Input.set_mouse_mode(target_mouse_mode)

func add_impulse(impulse: Vector3):
	velocity += transform.basis * impulse

func _physics_process(delta):
	if not is_multiplayer_authority() or not active: return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += gravity * delta
		if Input.is_action_pressed("slam"):
			velocity.y -= 60 * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		jump.play()
		

	var deceleration = deceleration_speed
	if !is_on_floor():
		deceleration = deceleration_speed * 0.8

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		current_acceleration += acceleration_speed * delta
		current_acceleration = clamp(current_acceleration, 0, 1)
		var current_speed = speed * acceleration_curve.sample(current_acceleration)
		
		#Dash
		if Input.is_action_just_pressed("dash") and dash_cooldown.is_stopped():
			velocity += direction * 40 + direction * velocity.length()
			dash_cooldown.start()
			dash_sound.play()
		
		var temp_velocity = Vector2(velocity.x, velocity.z)
		temp_velocity = lerp(temp_velocity, Vector2(direction.x * current_speed, direction.z * current_speed), deceleration * delta)
		velocity.x = temp_velocity.x
		velocity.z = temp_velocity.y
	else:
		var temp_velocity = Vector2(velocity.x, velocity.z)
		temp_velocity = lerp(temp_velocity, Vector2.ZERO, deceleration * delta)
		velocity.x = temp_velocity.x
		velocity.z = temp_velocity.y

	move_and_slide()

func hit_remote(source_path: NodePath):
	rpc_id(get_multiplayer_authority(), "hit", source_path)

func parry_remote(source_path: NodePath):
	rpc_id(get_multiplayer_authority(), "parried", source_path)
	
func hurt_remote(source_path: NodePath):
	rpc_id(get_multiplayer_authority(), "hurt", source_path)

@rpc("call_local", "any_peer")
func hit(source_path: NodePath):
	if not is_multiplayer_authority(): return
	print("Player hit!!!")
	on_hit.emit(source_path)

@rpc("call_local", "any_peer")
func parried(source_path: NodePath):
	if not is_multiplayer_authority(): return
	on_parried.emit(source_path)
	attack_state_controller.set_state($AttackStateController/Parried)

@rpc("call_local", "any_peer")
func hurt(source_path: NodePath):
	hurt_sound.play()
	if not is_multiplayer_authority(): return
	var source_player: Player = get_node(source_path)
	if source_player:
		var direction = (source_player.global_position - global_position).normalized()
		velocity += direction * -70 + direction * -source_player.velocity.length()
