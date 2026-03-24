extends State

var knife: Knife
var player: Player

func _ready() -> void:
	player = owner

func on_enter():
	rpc_id(1, "spawn_knife", get_multiplayer_authority())
	
func on_exit():
	pass
	
func process(_delta: float):
	pass


@rpc("call_local", "any_peer")
func spawn_knife(source):
	knife = preload("res://Content/Knife/knife.tscn").instantiate()
	knife.player = player
	knife.global_transform = %Camera.global_transform
	knife.retrieved.connect(knife_retrieved)
	player.replicate(knife)

func knife_retrieved():
	if not active: return
	knife.retrieved.disconnect(knife_retrieved)
	state_controller.set_state(%Idle)
