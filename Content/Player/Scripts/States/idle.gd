extends State

@onready var parry: Node = $"../Parry"
@onready var idle_tex: TextureRect = $CanvasLayer/IdleTex
@onready var attack: Node = $"../Attack"
@onready var player: Player = $"../.."

func _ready() -> void:
	player.on_hit.connect(on_hit)

func on_hit(source_path: NodePath):
	if not active: return
	player.hurt_remote(source_path)

func on_enter():
	idle_tex.visible = true
	
func on_exit():
	idle_tex.visible = false

func process(_delta: float):
	if Input.is_action_just_pressed("block"):
		state_controller.set_state(parry)
		return
		
	if Input.is_action_just_pressed("attack"):
		state_controller.set_state(attack)
		return
