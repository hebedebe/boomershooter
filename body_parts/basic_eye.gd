extends Node

@export var ranged_accuracy : float = 65

func apply_attributes(player_attributes):
	player_attributes.ranged_accuracy -= ranged_accuracy
