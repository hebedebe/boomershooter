extends State

@onready var block: State = $"../Block"
@onready var idle_tex: TextureRect = $CanvasLayer/IdleTex
@onready var attack: Node = $"../Attack"

func on_enter():
	idle_tex.visible = true
	
func on_exit():
	idle_tex.visible = false

func process(_delta: float):
	if Input.is_action_just_pressed("block"):
		state_controller.set_state(block)
		return
		
	if Input.is_action_just_pressed("attack"):
		state_controller.set_state(attack)
		return
