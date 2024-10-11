extends Node

@export var base_speed : float = 1.5
@export var sprint_speed : float = 3
@export var crouch_speed : float = 0.5
@export var jump_velocity : float = 1.65

func apply_attributes(player_attributes):
	player_attributes.base_speed += base_speed
	player_attributes.sprint_speed += sprint_speed
	player_attributes.crouch_speed += crouch_speed
	player_attributes.jump_velocity += jump_velocity
