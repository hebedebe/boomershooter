extends Node

@export var melee_range : float = 1.5
@export var melee_damage : float = 0.5

func apply_attributes(player_attributes):
	player_attributes.melee_range = clamp(player_attributes.melee_range, melee_range, 99)
	player_attributes.melee_damage += melee_damage
