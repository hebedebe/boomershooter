extends ProgressBar

@onready var player_attribute = $"../../PlayerAttributes"

@onready var healthText := $"../Health"
@onready var healthBar := $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var max_health = player_attribute.max_health
	var health = player_attribute.health
	
	max_value = max_health
	value = health
	
	healthText.text = str(health)+"/"+str(max_health)
