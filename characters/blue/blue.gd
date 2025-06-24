extends Character

var default_acts: Array[Act]= [
	Act.new("Check")
]

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

func do_animation(p_animation: Animations) -> Signal:
	match p_animation:
		Animations.IDLE:
			$AnimationPlayer.play("idle")
		Animations.PREP_ATTACK:
			$AnimationPlayer.play("prep_attack")
		Animations.PREP_ACT:
			$AnimationPlayer.play("prep_act")
		Animations.PREP_ITEM:
			$AnimationPlayer.play("prep_act")
		Animations.PREP_SPARE:
			$AnimationPlayer.play("prep_act")
		Animations.ATTACK:
			$AnimationPlayer.play("attack")
		Animations.ACT:
			$AnimationPlayer.play("act")
		Animations.USE_ITEM:
			$AnimationPlayer.play("act")
		Animations.DEFEND:
			$AnimationPlayer.play("defend")
		Animations.SPARE:
			$AnimationPlayer.play("act")
		Animations.FAINT:
			$AnimationPlayer.play("faint")
		Animations.REVIVE:
			$AnimationPlayer.play("RESET")
			$AnimationPlayer.play("idle")
	return $AnimationPlayer.animation_finished

func do_act(p_monster: Monster, p_act: int) -> void:
	var act := get_acts()[p_act]
	await do_animation(Animations.ACT)
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
	do_animation(Animations.IDLE)
	act_finished.emit()
