extends State

@onready var duration: Timer = $Duration
@onready var idle: Node = $"../Idle"

func _ready() -> void:
	duration.timeout.connect(go_idle)
	
func go_idle():
	state_controller.set_state(idle)

func on_enter():
	duration.start()
	
func on_exit():
	duration.stop()
