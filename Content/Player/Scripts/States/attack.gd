extends State

const IMPULSE_FORCE: float = 30;

@onready var attack_tex: TextureRect = $CanvasLayer/AttackTex
@onready var player: Player = $"../.."
@onready var duration: Timer = $Duration
@onready var attack_cooldown: Node = $"../AttackCooldown"
@onready var attack: AudioStreamPlayer = $Attack
@onready var attack_cast: ShapeCast3D = $"../../Neck/Camera/AttackCast"

func _ready() -> void:
	duration.timeout.connect(cooldown)
	player.on_hit.connect(on_hit)

func on_hit(source_path: NodePath):
	if not active: return
	player.hurt_remote(source_path)

func on_enter():
	attack_tex.visible = true
	player.add_impulse(player.camera.basis * Vector3(0,0,-IMPULSE_FORCE))
	duration.start()
	attack.play()
	
	attack_cast.force_shapecast_update() #bypasses enabled being off
	for i in range(attack_cast.get_collision_count()):
		var hit_object = attack_cast.get_collider(i)
		if hit_object is Player and hit_object != player:
			hit_object.hit_remote(player.get_path())
			print("Hit")
	
func cooldown():
	state_controller.set_state(attack_cooldown)

func on_exit():
	attack_tex.visible = false
	duration.stop()
