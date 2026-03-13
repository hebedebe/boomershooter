extends State

@onready var duration: Timer = $Duration
@onready var attack_cooldown: State = $"../AttackCooldown"
@onready var player: Player = $"../.."

func _ready() -> void:
	duration.timeout.connect(go_cooldown)
	player.on_hit.connect(on_hit)

func on_hit(source_path: NodePath):
	if not active: return
	player.hurt_remote(source_path)
	
func go_cooldown():
	state_controller.set_state(attack_cooldown)

func on_enter():
	duration.start()
	player.active = false
	%BrokenGlass.glass_fall()
	
func on_exit():
	duration.stop()
	player.active=true
