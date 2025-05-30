extends Character

var shake := 0.0
var default_acts: Array[Act]= [
	Act.new("Check")
]

func shake_sprite(amount: float) -> void:
	shake = amount

func _process(delta: float) -> void:
	if shake > 0.0:
		shake = lerpf(shake, 0.0, 1.0 - pow(0.1, delta))
		$BlueRobot.position = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
		if shake <= 0.1:
			shake = 0.0
			$BlueRobot.position = Vector2.ZERO

func get_acts() -> Array[Act]:
	var acts := default_acts.duplicate()
	var slime_found := false
	for monster: Monster in Global.monsters:
		if monster is Slime and !slime_found:
			acts.append_array([
				Act.new("Scare"),
				Act.new("Dribble"),
				Act.new("Jump"),
			])
			slime_found = true
	return acts

func idle() -> void:
	$AnimationPlayer.play("idle")

func prep_attack() -> void:
	$AnimationPlayer.play("prep_attack")

func do_attack(p_monster: Monster, p_damage: int) -> void:
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	if p_monster:
		p_monster.take_damage(self, p_damage)
		p_monster.damage_or_die_animation()
	await get_tree().create_timer(0.2).timeout
	idle()

func prep_act() -> void:
	$AnimationPlayer.play("prep_act")

func do_act(p_monster: Monster, p_act: int) -> void:
	var act := get_acts()[p_act]
	$AnimationPlayer.play("act")
	await get_tree().create_timer(0.01).timeout
	match act.title:
		"Check":
			Global.display_text.emit(p_monster.description, true)
			await Global.text_finished
		"Scare":
			Global.display_text.emit("  * You jumped out at the slime!", true)
			await Global.text_finished
			await get_tree().create_timer(0.01).timeout
			Global.display_text.emit("  * It bounced much higher.", true)
			p_monster.increase_mercy(0.3)
			await Global.text_finished
		"Dribble":
			Global.display_text.emit("  * You tried to dribble the slime like [color=#000]----[/color]a basketball!", true)
			await Global.text_finished
			await get_tree().create_timer(0.01).timeout
			Global.display_text.emit("  * It's more confused than anything.", true)
			p_monster.increase_mercy(0.05)
			await Global.text_finished
		"Jump":
			Global.display_text.emit("  * You jumped along with the slime!", true)
			await Global.text_finished
			await get_tree().create_timer(0.01).timeout
			Global.display_text.emit("  * The slime jumps even higher.", true)
			p_monster.increase_mercy(0.15)
			await Global.text_finished
	idle()
	act_finished.emit()

func prep_item() -> void:
	$AnimationPlayer.play("prep_act")

func use_item(p_character: Character, p_item: int) -> void:
	$AnimationPlayer.play("act")
	await $AnimationPlayer.animation_finished
	super(p_character, p_item)
	idle()

func prep_spare() -> void:
	$AnimationPlayer.play("prep_act")

func do_spare(p_monster: Monster) -> void:
	$AnimationPlayer.play("act")
	super(p_monster)
	await $AnimationPlayer.animation_finished
	idle()

func defend() -> void:
	$AnimationPlayer.play("defend")
	defending = true

func faint() -> void:
	alive = false
	$AnimationPlayer.play("faint")
	await $AnimationPlayer.animation_finished
	faint_finished.emit()

func revive() -> void:
	alive = true
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("idle")

func hurt(p_damage: int) -> void:
	shake_sprite(4.0)
	super(p_damage)
