extends Node

var max_health : int = 100
var health : int = 100

#player controller
@onready var player_controller = $".."

# body part slots
@onready var left_eye_slot = $left_eye_slot
@onready var right_eye_slot = $right_eye_slot
@onready var left_arm_slot = $left_arm_slot
@onready var right_arm_slot = $right_arm_slot
@onready var left_leg_slot = $left_leg_slot
@onready var right_leg_slot = $right_leg_slot

func _process(delta: float) -> void:
	reset_attributes()
	
	left_eye_slot.manage_body_part(player_controller)
	right_eye_slot.manage_body_part(player_controller)
	left_arm_slot.manage_body_part(player_controller)
	right_arm_slot.manage_body_part(player_controller)
	left_leg_slot.manage_body_part(player_controller)
	right_leg_slot.manage_body_part(player_controller)

func reset_attributes():
	player_controller.base_speed = 0
	#player_controller.sprint_speed = 0
