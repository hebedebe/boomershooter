extends GPUParticles3D

@onready var player: Player = $"../.."

#func _ready() -> void:
	#emitting = not is_multiplayer_authority() and player.get_real_velocity().length() > 0.1
