extends State

var knife: Knife
var player: Player

func _ready() -> void:
	player = owner

func on_enter():
	knife = preload("res://Content/Knife/knife.tscn").instantiate()
	knife.player = player
	knife.global_transform = %Camera.global_transform
	knife.retrieved.connect(knife_retrieved)
	player.replicate(knife)
	
func on_exit():
	pass
	
func process(_delta: float):
	pass


func knife_retrieved():
	if not active: return
	knife.retrieved.disconnect(knife_retrieved)
	state_controller.set_state(%Idle)
