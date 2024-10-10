extends Node


func manage_body_part(player_controller : CharacterBody3D):
	var body_part = get_child(0)
	if body_part == null:
		return
	body_part.apply_attributes(player_controller)
