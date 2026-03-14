extends Node3D

@onready var platform: Node3D = $"."
@onready var marker: CSGSphere3D = $MarkerSphere
@onready var area_3d: Area3D = $Platform/Area3D

@export var checkpoints: Array[Node3D]
@export var start_index: int = 0
@export var move_speed: float = 1
@export var required_distance: float = 0.1
@export var show_marker: bool = false

var checkpoint_index: int = 0
var contained_players: Array[Player]

func _ready() -> void:
	area_3d.body_entered.connect(collision_enter)
	area_3d.body_exited.connect(collision_exit)
	
	checkpoint_index = start_index
	platform.global_position = checkpoints[checkpoint_index].global_position
	checkpoint_index += 1

func get_current_checkpoint() -> Node3D:
	return checkpoints[checkpoint_index % len(checkpoints)]

func _physics_process(delta: float) -> void:
	var checkpoint = get_current_checkpoint()
	var distance = checkpoint.global_position.distance_to(platform.global_position)
	if distance < required_distance:
		checkpoint_index += 1
		checkpoint = get_current_checkpoint()
	var direction = (checkpoint.global_position - platform.global_position).normalized()
	var velocity = direction * move_speed * delta
	platform.global_position += velocity
	
	for player in contained_players:
		player.position += velocity
	
	marker.visible = show_marker
	marker.global_position = checkpoint.global_position
	
func collision_enter(body):
	if body is Player and not contained_players.has(body):
		contained_players.append(body)
	
func collision_exit(body):
	if body is Player and contained_players.has(body):
		contained_players.erase(body)
