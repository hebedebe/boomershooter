extends Node

func apply_attributes(player_attributes):
	player_attributes.base_speed += 1.5
	player_attributes.sprint_speed += 3
	player_attributes.crouch_speed += 0.5
	player_attributes.jump_velocity += 2.25
