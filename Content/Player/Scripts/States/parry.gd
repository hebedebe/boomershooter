extends State

@export var max_duration: float = 1
@export var release_is_cancel: bool = true

# Timers
@onready var duration: Timer = $Duration

@onready var block: Node = $"../Block"
@onready var block_tex: TextureRect = $CanvasLayer/BlockTex
@onready var player: Player = $"../.."
@onready var blocking_hum: AudioStreamPlayer = $BlockingHum
@onready var parry: AudioStreamPlayer = $Parry

func _ready() -> void:
	duration.wait_time = max_duration
	duration.timeout.connect(stop_parrying)
	player.on_hit.connect(on_hit)

func on_enter():
	duration.start()
	block_tex.visible = true
	player.add_impulse(Vector3(0,0,40))
	blocking_hum.play()

func process(_delta: float):
	block_tex.modulate = Color(1.0, 1.0, 1.0, 1.0).lerp(Color(1.0, 1.0, 0.0, 1.0), duration.time_left/duration.wait_time)
	if release_is_cancel:
		if not Input.is_action_pressed("block"):
			stop_parrying()

func on_exit():
	duration.stop()
	block_tex.visible = false
	blocking_hum.stop()

func stop_parrying():
	state_controller.set_state(block)

func on_hit(source_path: NodePath):
	if not active: return
	parry.play()
	var source_player: Player = get_node(source_path)
	if source_player:
		source_player.parry_remote(player.get_path())
	else:
		push_warning("Invalid player in on_hit")
	state_controller.set_state($"../Idle")
	
