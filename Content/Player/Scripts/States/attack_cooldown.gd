extends State

@onready var cooldown: Timer = $Cooldown
@onready var idle: Node = $"../Idle"
@onready var idle_tex: TextureRect = $CanvasLayer/IdleTex
@onready var overheat: AudioStreamPlayer = $Overheat

func _ready() -> void:
	cooldown.timeout.connect(go_idle)
	
func on_enter():
	cooldown.start()
	idle_tex.visible = true
	overheat.play()
	
func process(_delta: float):
	idle_tex.modulate = Color(1.0, 1.0, 1.0, 1.0).lerp(Color(1.0, 0.0, 0.0, 1.0), cooldown.time_left/cooldown.wait_time)

	
func on_exit():
	cooldown.stop()
	idle_tex.visible = false
	
func go_idle():
	state_controller.set_state(idle)
