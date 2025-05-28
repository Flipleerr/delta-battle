extends Character

var shake := 0.0

func shake_sprite(amount: float) -> void:
	shake = amount

func _process(delta: float) -> void:
	if shake > 0.0:
		shake = lerpf(shake, 0.0, 1.0 - pow(0.1, delta))
		$BlueRobot.position = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
		if shake <= 0.1:
			shake = 0.0
			$BlueRobot.position = Vector2.ZERO

func idle() -> void:
	$AnimationPlayer.play("idle")

func prep_attack() -> void:
	$AnimationPlayer.play("prep_attack")

func do_attack(p_monster: Monster, p_damage: int) -> void:
	p_monster.take_damage(self, p_damage)
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	if p_monster:
		p_monster.damage_or_die_animation()
	await get_tree().create_timer(0.2).timeout
	idle()

func prep_act() -> void:
	$AnimationPlayer.play("prep_act")

func do_act(_p_monster: Monster, _p_act: int) -> void:
	$AnimationPlayer.play("act")

func defend() -> void:
	$AnimationPlayer.play("defend")
	defending = true

func faint() -> void:
	alive = false
	$AnimationPlayer.play("faint")

func revive() -> void:
	alive = true
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("idle")

func hurt(p_damage: int) -> void:
	shake_sprite(4.0)
	super(p_damage)
