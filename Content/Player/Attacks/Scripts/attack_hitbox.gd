class_name AttackHitbox
extends Node3D

@onready var area_3d: Area3D = $Area3D

var owning_player: Player

func _ready() -> void:
	area_3d.body_entered.connect(attack_entered)
	print("attack hitbox created")

func attack_entered(body: Node3D):
	if body is Player:
		if body != owning_player:
			body.hit()
