extends CharacterBody2D
class_name Soul

const SPEED := 4.0 * 30.0 # 4 pixels per frame
const SLOW_MULTIPLIER := 0.5
const TP_INDICATOR_DISSIPATE := 30.0 / 9.0 # Fully disappears in 9 frames
var active := false

func _physics_process(delta: float) -> void:
	if $TPIndicator.modulate.a != 0.0:
		$TPIndicator.modulate.a -= TP_INDICATOR_DISSIPATE * delta
		$TPIndicator.modulate.a = maxf(0.0, $TPIndicator.modulate.a) 
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

func hurt(p_damage: int) -> void:
	get_parent().hurt(5 * p_damage)

func _on_tp_range_area_entered(_area: Area2D) -> void:
	Global.tp += 1
	$TPIndicator.modulate.a = 1.0
	Sounds.play("snd_graze", 0.7)
