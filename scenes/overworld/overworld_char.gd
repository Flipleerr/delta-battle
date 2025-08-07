extends CharacterBody2D

const SPEED = 80.0

func _physics_process(_delta: float) -> void:
	var input := Vector2(
		int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	)

	velocity = Vector2.ZERO
	if input != Vector2.ZERO:
		velocity = SPEED * input
		if Input.is_action_pressed("cancel"):
			velocity *= 2
			$AnimatedSprite2D.set_speed_scale(1.5)
		else:
			$AnimatedSprite2D.set_speed_scale(1)

	if Input.is_action_pressed("right"):
		$AnimatedSprite2D.play("walk_right")

	elif Input.is_action_pressed("left"):
		$AnimatedSprite2D.play("walk_left")

	elif Input.is_action_pressed("up"):
		$AnimatedSprite2D.play("walk_up")

	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.play("walk_down")

	elif velocity == Vector2.ZERO:
		$AnimatedSprite2D.pause()

	move_and_slide()
