@tool
extends "res://addons/LineRenderer/line_renderer.gd"

@onready var line_start: Node3D = %LineStart
@onready var knife: Knife = $".."


func _ready():
	points.append(line_start.global_position)
	points.append(knife.player.global_position)
	
func _process(_delta):
	points[0] = line_start.global_position
	points[1] = knife.player.global_position
