class_name PlayerCamera
extends Camera3D

@export var tilt_strength: Vector2

@onready var player: Player = $"../.."
@onready var neck: Node3D = $".."

func _ready() -> void:
	current = is_multiplayer_authority()
		

func get_local_velocity() -> Vector3:
	return player.global_transform.basis.inverse() * player.velocity

func _process(_delta: float) -> void:
	var local_velocity = get_local_velocity()
	var lateral_velocity = Vector2(local_velocity.z, -local_velocity.x) #Change to local velocity
	var tilt_amount = lateral_velocity * tilt_strength
	rotation_degrees = Vector3(tilt_amount.x, 0, tilt_amount.y)
