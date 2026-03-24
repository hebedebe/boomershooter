class_name Knife extends Node3D

signal throw_time_finished
signal retrieved
signal hit

@export var speed: float

@onready var throw_timer: Timer = $ThrowTimer

var player: Player
var retrieving: bool = false
var collided: bool = false

func _ready() -> void:
	if is_multiplayer_authority():
		assert(player, "Knife must be assigned player before ready.")
		throw_timer.start()
		await throw_timer.timeout
		throw_time_finished.emit()
		
		retrieving = true

	
func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		if retrieving:
			var tween = create_tween()
			tween.tween_property(self, "global_position", player.global_position, 0.1)
			if global_position.distance_to(player.global_position) < 1:
				retrieved.emit()
				queue_free()
		else:
			if not collided:
				position += transform.basis * Vector3(0,0,-speed * delta)

func knife_collided(body: Node3D):
	if is_multiplayer_authority():
		if body != player:
			collided = true
			hit.emit()
			if body is Player:
				body.hit_remote(player.get_path())
