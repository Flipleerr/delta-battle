extends Area2D
class_name Pellet

@export var damage := 1

func _on_body_entered(body: Node2D) -> void:
	if body is Soul:
		body.hurt(damage)
