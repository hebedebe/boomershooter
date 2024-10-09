extends OmniLight3D

@export var noise: NoiseTexture3D
@export var frequency: float
var time_passed := 0.0
var start_energy = 0

func _ready():
	start_energy = light_energy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	#print(time_passed)
	
	var sampled_noise = noise.noise.get_noise_1d(time_passed * frequency)
	sampled_noise = abs(sampled_noise)
	
	light_energy = start_energy-sampled_noise*(0.7 * start_energy)
	pass
