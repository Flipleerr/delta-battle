extends Control
class_name CharMenu

const PURPLE := Color("#332033")

var main_color := Color.WHITE:
	set(p_main_color):
		main_color = p_main_color
		var health_box: StyleBoxFlat = $Stats/HealthBar.get_theme_stylebox("fill")
		health_box.bg_color = main_color
var current_hp := 100:
	set(p_current_hp):
		current_hp = p_current_hp
		$Stats/HealthBar.value = maxi(0, current_hp)
		$Stats/CurrentHP.text = str(current_hp)
		update_hp_color()
var max_hp := 100:
	set(p_max_hp):
		max_hp = p_max_hp
		$Stats/HealthBar.max_value = maxi(1, max_hp)
		$Stats/MaxHP.text = str(max_hp)
		update_hp_color()
var can_spare:
	set(p_can_spare):
		can_spare = p_can_spare
		actions[Global.SPARE].flashing = can_spare
var uses_magic:
	set(p_uses_magic):
		actions[Global.ACT] = $Actions/Magic
		$Actions/Magic.visible = true
		$Actions/Act.visible = false

var actions: Array[CharMenuButton] = []
var activated := false:
	set(p_activated):
		activated = p_activated
		for action: CharMenuButton in actions:
			action.activated = activated
var focused := false:
	set(p_focused):
		focused = p_focused
		selected_item = selected_item
var selected_item := 0:
	set(p_selected_item):
		actions[selected_item].selected = false
		selected_item = p_selected_item
		actions[selected_item].selected = true

var style_box: StyleBoxFlat

func _ready() -> void:
	actions = [
		$Actions/Attack,
		$Actions/Act,
		$Actions/Item,
		$Actions/Spare,
		$Actions/Defend
	]
	style_box = $Stats.get_theme_stylebox("panel")
	style_box = style_box.duplicate()
	$Stats.add_theme_stylebox_override("panel", style_box)
	$Actions.add_theme_stylebox_override("panel", style_box)

func _unhandled_key_input(p_event: InputEvent) -> void:
	if focused and p_event is InputEventKey and p_event.is_pressed():
		if p_event.is_action("left"):
			selected_item = wrapi(selected_item - 1, 0, 5)
		elif p_event.is_action("right"):
			selected_item =  wrapi(selected_item + 1, 0, 5)

func update_hp_color() -> void:
	if current_hp < 0.2 * $Stats/HealthBar.max_value:
		($Stats/CurrentHP.label_settings as LabelSettings).font_color = Global.YELLOW
		($Stats/MaxHP.label_settings as LabelSettings).font_color = Global.YELLOW
	else:
		($Stats/CurrentHP.label_settings as LabelSettings).font_color = Color.WHITE
		($Stats/MaxHP.label_settings as LabelSettings).font_color = Color.WHITE

func set_from_character(character: Character) -> void:
	$Stats/Name.text = character.title
	current_hp = character.current_hp
	max_hp = character.max_hp
	main_color = character.main_color
	$Stats/Icon.texture = character.icon

func activate():
	$Cover1.visible = false
	$Cover2.visible = false
	style_box.border_color = main_color
	activated = true
	focused = true
	
	if $Stats.position.y == -32.0:
		return
	
	$Stats.position.y = -16.0
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Stats, "position", Vector2($Stats.position.x, -32.0), 1.0 / 6.0)

func deactivate():
	style_box.border_color = PURPLE
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Stats, "position", Vector2($Stats.position.x, 0.0), 1.0 / 10.0)
	$Cover1.visible = true
	$Cover2.visible = true
	
	activated = false
	focused = false
