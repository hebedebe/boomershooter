extends Node

@export var part_type = "" #leg, arm, eye, etc

func apply_attributes(player_controller: CharacterBody3D):
	get_child(0).apply_attributes(player_controller)
