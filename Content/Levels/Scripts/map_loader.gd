class_name MapLoader
extends Node3D

@export var maps: Array[PackedScene] = []
@export var selected_index: int = 0

@onready var network: NetworkManager = $"../Network"

var current_map: Node3D

func _ready() -> void:
	network.server_started.connect(spawn_selected_map)

func spawn_random_map():
	load_map_from_packed_scene(maps.pick_random())

func spawn_selected_map():
	load_map_from_packed_scene(maps[selected_index])

func next_index():
	selected_index = (selected_index+1)%len(maps)

func load_map(map: Node3D):
	if current_map:
		current_map.queue_free()
	current_map = map
	network.replicate(map)

func load_map_from_packed_scene(scene: PackedScene):
	var map: Node3D = scene.instantiate()
	load_map(map)

func load_map_from_string(id: String):
	var map: Node3D = load(id).new()
	load_map(map)
	
