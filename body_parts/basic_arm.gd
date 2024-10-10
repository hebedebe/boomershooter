extends Node

func apply_attributes(player_attributes):
	player_attributes.melee_range = clamp(player_attributes.melee_range, 1.5, 99)
	player_attributes.melee_damage += 0.5
