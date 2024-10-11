extends Node

var max_health : int = 100
var health : int = 100

#movement attributes
var base_speed : float = 3.0
var sprint_speed : float = 6.0
var crouch_speed : float = 1.0
var jump_velocity : float = 4.5

#other attributes
var melee_range : float = 1.5
var melee_damage : float = 1
var ranged_accuracy : float = 180 # measured in degrees as fov

#player controller
@onready var player_controller = $".."

# body part slots
@onready var left_eye_slot = $LeftEyeSlot
@onready var right_eye_slot = $RightEyeSlot
@onready var left_arm_slot = $LeftArmSlot
@onready var right_arm_slot = $RightArmSlot
@onready var left_leg_slot = $LeftLegSlot
@onready var right_leg_slot = $RightLegSlot

func _process(delta: float) -> void:
	reset_attributes()
	
	left_eye_slot.manage_body_parts(self)
	right_eye_slot.manage_body_parts(self)
	left_arm_slot.manage_body_parts(self)
	right_arm_slot.manage_body_parts(self)
	left_leg_slot.manage_body_parts(self)
	right_leg_slot.manage_body_parts(self)
	
	player_controller.base_speed = base_speed
	player_controller.sprint_speed = sprint_speed
	player_controller.crouch_speed = crouch_speed
	player_controller.jump_velocity = jump_velocity
	
	player_controller.jumping_enabled = not jump_velocity <= 0
	
	player_controller.handle_state(true)

func reset_attributes():
	base_speed = 0
	sprint_speed = 0
	crouch_speed = 0
	jump_velocity = 0
	melee_range = 0
	ranged_accuracy = 180 #lower is better
