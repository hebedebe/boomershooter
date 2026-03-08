extends State

@onready var duration: Timer = $Duration
@onready var block_cooldown: State = $"../BlockCooldown"
@onready var block_tex: TextureRect = $CanvasLayer/BlockTex
@onready var player: Player = $"../.."
@onready var blocking_hum: AudioStreamPlayer = $BlockingHum

func _ready() -> void:
	duration.timeout.connect(stop_blocking)

func on_enter():
	duration.start()
	block_tex.visible = true
	player.add_impulse(Vector3(0,0,40))
	blocking_hum.play()

func process(_delta: float):
	block_tex.modulate = Color(1.0, 0.0, 0.0, 1.0).lerp(Color(1.0, 1.0, 1.0, 1.0), duration.time_left/duration.wait_time)
	if not Input.is_action_pressed("block"):
		stop_blocking()

func on_exit():
	duration.stop()
	block_tex.visible = false
	blocking_hum.stop()

func stop_blocking():
	state_controller.set_state(block_cooldown)
