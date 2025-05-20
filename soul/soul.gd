extends CharacterBody2D

const SPEED := 4.0 * 30.0 # 4 pixels per frame
const SLOW_MULTIPLIER := 0.5
var active := false

func _physics_process(_delta: float) -> void:
	if !active:
		return
	
	var input := Vector2(
		int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	).normalized()
	
	velocity = Vector2.ZERO
	if input != Vector2.ZERO:
		velocity = SPEED * input
		if Input.is_action_pressed("cancel"):
			velocity *= 0.5
	move_and_slide()
