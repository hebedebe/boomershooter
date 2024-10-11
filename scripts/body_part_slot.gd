extends Node

@export var part_type = ""
@export var slot_name = ""

func manage_body_parts(player_attributes):
	var body_parts = get_children()
	for part in body_parts:
		if part == null:
			return
		part.apply_attributes(player_attributes)

func verify_part_validity(part):
	var body_part = get_child(0)
	if body_part == null:
		if part.is_minor:
			return false
		else:
			return (part_type in part.part_type)
	else:
		return (part.is_minor and part_type in part.part_type)
