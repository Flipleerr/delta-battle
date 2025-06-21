extends Monster
class_name Slime

var shake := 0.0
var velocity := 0.0
var squishing := false
var hurting := false

var attacks: Array[Node2D] = []

func shake_sprite(amount: float) -> void:
	shake = amount

func _ready() -> void:
	await get_tree().create_timer(randf_range(0.0, 0.6)).timeout
	super()

func _process(delta: float) -> void:
	if shake > 0.0:
		shake = lerpf(shake, 0.0, 1.0 - pow(0.1, delta))
		$Sprite.position = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
		if shake <= 0.1:
			shake = 0.0
			$Sprite.position = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if shake > 0.0 or squishing or hurting or dying:
		return
	if $Sprite.position.y > 0.0:
		velocity = remap(mercy_percent, 0.0, 1.0, 160.0, 240.0)
		$Sprite.frame = 1
		$Sprite.position.y = 0.0
		squishing = true
		await get_tree().create_timer(0.2).timeout
		squishing = false
		return
	$Sprite.position.y -= velocity * delta
	$Sprite.frame = 0 if absf(velocity) < 48.0 else 2
	velocity -= 196.0 * delta

func get_opening_line() -> String:
	for monster: Monster in Global.monsters:
		if monster == self:
			continue
		if monster is Slime:
			return "  * The slimes bounced into battle!"
	return "  * A slime bounced into battle!"

func get_idle_line() -> String:
	return [
		"  * The ground is covered in slime...",
		"  * You feel like jumping around.",
		"  * The slime is bouncing around even [color=#000]----[/color]faster!",
		"  * Don't get slimed!",
		"  * The slime looks extra squishy..."
	].pick_random()

func damage_or_die_animation() -> void:
	if !dying:
		$AnimationPlayer.play("hurt")
		hurting = true
		await $AnimationPlayer.animation_finished
		hurting = false
		velocity = 0.0
		squishing = false
	else:
		$AnimationPlayer.play("hurt")
		await $AnimationPlayer.animation_finished
		shake = 0.0
		$AnimationPlayer.play("die")
		await $AnimationPlayer.animation_finished
		exit_finished.emit()
		queue_free()

func spare() -> void:
	shake = 0.0
	$AnimationPlayer.play("spare")
	await $AnimationPlayer.animation_finished
	super()

func start_attack() -> float:
	var another_slime := false
	for monster: Monster in Global.monsters:
		if monster == self:
			continue
		if monster is Slime:
			another_slime = true
			break
	attacks.clear()
	var attack := randi_range(0, 1 if !another_slime else 4)
	match attack:
		0:
			var slime_bounce := preload("res://monsters/slime/attacks/slime_bounce/slime_bounce.tscn").instantiate()
			get_parent().add_child(slime_bounce)
			slime_bounce.position = Global.CENTER
			attacks.append(slime_bounce)
		1:
			var slime_drip := preload("res://monsters/slime/attacks/slime_drip/slime_drip.tscn").instantiate()
			get_parent().add_child(slime_drip)
			slime_drip.position = Global.CENTER
			attacks.append(slime_drip)
		_:
			var slime_bounce := preload("res://monsters/slime/attacks/slime_bounce/slime_bounce.tscn").instantiate()
			get_parent().add_child(slime_bounce)
			slime_bounce.position = Global.CENTER
			
			var slime_drip := preload("res://monsters/slime/attacks/slime_drip/slime_drip.tscn").instantiate()
			get_parent().add_child(slime_drip)
			slime_drip.position = Global.CENTER
			
			attacks.append(slime_bounce)
			attacks.append(slime_drip)
	return 8.0

func end_attack() -> void:
	for attack: Node2D in attacks:
		if attack != null:
			attack.queue_free()
	attacks.clear()
