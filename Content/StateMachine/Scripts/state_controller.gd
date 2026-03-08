class_name StateController
extends Node

@export var state: State
@export var require_network_authority: bool = true

func _ready() -> void:
	if require_network_authority and not is_multiplayer_authority(): return
	
	if state:
		state.enter()
	else:
		push_warning("No default state assigned to ", name)
	
	for child in get_children():
		if child is State:
			child.state_controller = self

func _process(delta: float) -> void:
	if require_network_authority and not is_multiplayer_authority(): return
	
	if state:
		state.process(delta)

func set_state(new_state: State):
	state.exit()
	state = new_state
	state.enter()
