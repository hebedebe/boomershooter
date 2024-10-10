extends Node

@export var part_type = "" #leg, arm, eye, etc
@export var is_minor = false # minor parts can be added into a slot with another part in it 
#but require a base part

func apply_attributes(player_attributes):
	get_child(0).apply_attributes(player_attributes)
