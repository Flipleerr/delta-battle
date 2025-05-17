extends Node2D

const PURPLE := Color("#332033")

var main_color := Color.WHITE
var current_hp := 80
var max_hp := 100

func set_current_hp(p_current_hp: int):
	current_hp = p_current_hp
	$Stats/HealthBar.value = maxi(0, current_hp)
	$Stats/CurrentHP.text = str(current_hp)
	update_hp_color()

func set_max_hp(p_max_hp: int):
	max_hp = p_max_hp
	$Stats/HealthBar.max_value = maxi(1, max_hp)
	$Stats/MaxHP.text = str(max_hp)
	update_hp_color()

func update_hp_color() -> void:
	if current_hp < 0.2 * $Stats/HealthBar.max_value:
		($Stats/CurrentHP.label_settings as LabelSettings).font_color = Global.YELLOW
		($Stats/MaxHP.label_settings as LabelSettings).font_color = Global.YELLOW
	else:
		($Stats/CurrentHP.label_settings as LabelSettings).font_color = Color.WHITE
		($Stats/MaxHP.label_settings as LabelSettings).font_color = Color.WHITE

func set_main_color(p_main_color: Color) -> void:
	main_color = p_main_color
	var style_box: StyleBoxFlat = $Stats/HealthBar.get_theme_stylebox("fill")
	style_box.bg_color = main_color

func activate():
	$Cover1.visible = false
	$Cover2.visible = false
	var upper_box: StyleBoxFlat = $Stats.get_theme_stylebox("panel")
	upper_box.border_color = main_color
	$Stats.position.y = -16.0
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Stats, "position", Vector2($Stats.position.x, -32.0), 1.0 / 6.0)

func deactivate():
	var upper_box: StyleBoxFlat = $Stats.get_theme_stylebox("panel")
	upper_box.border_color = PURPLE
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Stats, "position", Vector2($Stats.position.x, 0.0), 1.0 / 10.0)
	$Cover1.visible = true
	$Cover2.visible = true
