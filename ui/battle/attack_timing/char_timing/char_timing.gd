extends Control
class_name CharTiming

var active := false
var frame := 0

func set_from_character(p_character: Character) -> void:
	$Icon.texture = p_character.icon
	$PerfectHit.modulate = p_character.icon_color
	$HitRegion.modulate = p_character.main_color.darkened(0.5)

func set_active(p_active: bool) -> void:
	active = p_active
	for child: CanvasItem in get_children():
		child.visible = active
	$AttackIndicator.position.x = 410.0 + 96.0 * randi_range(-1, 1)
	frame = 0

func _process(delta: float) -> void:
	if !active:
		return
	if frame % 2 == 0:
		var new_shadow: Panel = $AttackIndicator.duplicate()
		new_shadow.modulate.a = 0.4
		$IndicatorShadows.add_child(new_shadow)
	for shadow: Panel in $IndicatorShadows.get_children():
		shadow.modulate.a -= 1.2 * delta
		if shadow.modulate.a <= 0.0:
			shadow.queue_free()
	frame += 1
	$AttackIndicator.position.x -= 8.0 * 30.0 * delta
