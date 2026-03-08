extends Node3D

@export var maps: Array[PackedScene] = []
@onready var network: Node = $"../Network"

func spawn_random_map():
	load_map_from_packed_scene(maps.pick_random())

func load_map(map: Node3D):
	for child in get_children():
		child.queue_free()
	network.replicate(map)

func load_map_from_packed_scene(scene: PackedScene):
	var map: Node3D = scene.instantiate()
	load_map(map)

func load_map_from_string(id: String):
	var map: Node3D = load(id).new()
	load_map(map)
	
