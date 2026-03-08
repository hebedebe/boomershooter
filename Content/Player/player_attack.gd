extends Node3D

@onready var holding_tex: TextureRect = $"../HUD/Canvas/HoldingTex"
@onready var player: Player = $".."

func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	if Input.get_action_strength("block"):
		holding_tex.texture = preload("res://Art/Textures/UI/hand_block.png")
	else:
		holding_tex.texture = preload("res://Art/Textures/UI/hand_default.png")

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	
	if event.is_action_pressed("attack"):
		print("attack")
		player.add_impulse(Vector3(0,0,-20))
		$"../HUD/Canvas/Slash".play()
	if event.is_action_pressed("block"):
		print("block")
		player.add_impulse(Vector3(0,0,20))
