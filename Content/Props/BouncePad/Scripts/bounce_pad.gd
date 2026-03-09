class_name BouncePad
extends Node3D

@export var bounce_force: float = 100

@onready var bounce_area: Area3D = $BounceArea

func _ready() -> void:
	bounce_area.body_entered.connect(body_entered)
	
func body_entered(body: Object):
	if body is Player:
		body.velocity.y = bounce_force
		var particles: Node3D = preload("res://Content/Particles/Bounce/bounce_particles.tscn").instantiate()
		add_child(particles)
		particles.position = Vector3.ZERO
