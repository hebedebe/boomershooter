extends State

@onready var attack_tex: TextureRect = $CanvasLayer/AttackTex
@onready var player: Player = $"../.."
@onready var camera: PlayerCamera = $"../../Neck/Camera"
@onready var duration: Timer = $Duration
@onready var attack_cooldown: Node = $"../AttackCooldown"
@onready var attack: AudioStreamPlayer = $Attack

func _ready() -> void:
	duration.timeout.connect(cooldown)

func on_enter():
	attack_tex.visible = true
	rpc_id(1, "create_attack")
	duration.start()
	attack.play()

@rpc("any_peer", "call_local")
func create_attack():
	var hitbox: AttackHitbox = preload("res://Content/Player/Attacks/attack_hitbox.tscn").instantiate()
	hitbox.owning_player = player
	hitbox.global_transform = camera.global_transform
	player.network_manager.replicate(hitbox)
	print("Attacked from player ", player.name)
	
func cooldown():
	state_controller.set_state(attack_cooldown)

func on_exit():
	attack_tex.visible = false
	duration.stop()
