class_name PlayerCamera
extends Camera3D

@export var do_tilt: bool = true
@export var do_bob: bool = true
@export var do_fov: bool = true

@export var tilt_strength: Vector2
@export var base_FOV: float = 90
@export var FOV_modifier: float = 1
@export var bob_strength: float = 0.1
@export var bob_speed: float = 1
@export var camera_lerp_speed: float = 10

@onready var player: Player = $"../.."
@onready var neck: Node3D = $".."

func _ready() -> void:
	current = is_multiplayer_authority()
		

func get_local_velocity() -> Vector3:
	return player.global_transform.basis.inverse() * player.velocity

func _process(delta: float) -> void:
	var local_velocity = get_local_velocity()
	var lateral_velocity = Vector2(local_velocity.z, -local_velocity.x) #Change to local velocity
	
	if do_tilt:
		var tilt_amount = lateral_velocity * tilt_strength
		rotation_degrees = Vector3(tilt_amount.x, 0, tilt_amount.y)
	
	if do_fov:
		fov = clamp(lerpf(fov, base_FOV + local_velocity.length()*FOV_modifier, 5*delta), 1, 150)
	
	if player.is_on_floor() and player.velocity.length() > 1 and do_bob:
		position.y = lerpf(position.y, position.y + bob_strength * sin(bob_speed * Time.get_ticks_msec()), camera_lerp_speed*delta)
	else:
		position.y = lerpf(position.y, 0, camera_lerp_speed*delta)
