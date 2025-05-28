extends Monster
class_name Slime

var shake := 0.0

func shake_sprite(amount: float) -> void:
	shake = amount

func _ready() -> void:
	await get_tree().create_timer(randf_range(0.0, 0.6)).timeout
	$AnimationPlayer.play("bounce")
	super()

func _process(delta: float) -> void:
	if shake > 0.0:
		shake = lerpf(shake, 0.0, 1.0 - pow(0.1, delta))
		$Sprite.position = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
		if shake <= 0.1:
			shake = 0.0
			$Sprite.position = Vector2.ZERO

func get_opening_line() -> String:
	for monster: Monster in Global.monsters:
		if monster == self:
			continue
		if monster is Slime:
			return "  * The slimes bounced into battle!"
	return "  * A slime bounced into battle!"

func take_damage(p_character: Character, p_damage: int) -> void:
	$AnimationPlayer.play("hurt")
	super(p_character, p_damage)
	if !dying:
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("bounce")
