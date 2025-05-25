extends Character

var shake := 0.0

func shake_sprite(amount: float) -> void:
	shake = amount

func _ready() -> void:
	$AnimationPlayer.play("idle")

func _process(delta: float) -> void:
	if shake > 0.0:
		shake = lerpf(shake, 0.0, 1.0 - pow(0.1, delta))
		$BlueRobot.position = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
		if shake <= 0.1:
			shake = 0.0
			$BlueRobot.position = Vector2.ZERO
