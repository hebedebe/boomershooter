extends Node

@export var part_type = ""

func manage_body_part(player_attributes):
	var body_part = get_child(0)
	if body_part == null:
		return
	body_part.apply_attributes(player_attributes)

func verify_part_validity(part):
	var body_part = get_child(0)
	if body_part == null:
		if part.is_minor:
			return false
		else:
			return (part.part_type == part_type)
	else:
		return (part.is_minor and part.part_type == part_type)
