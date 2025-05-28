extends Node2D
class_name Character

@export var title := ""
@export var current_hp := 100
@export var max_hp := 1
@export var strength := 0
@export var defense := 0
@export var uses_magic := false
@export_color_no_alpha var main_color := Color.WHITE
@export_color_no_alpha var icon_color := Color.GRAY
@export var icon: Texture2D = preload("res://ui/battle/char_menu/res/sample_char_icon.png")

var alive := true
var defending := false
signal health_changed(p_new_health: int)

func _ready() -> void:
	await get_tree().create_timer(randf_range(0.0, 0.6)).timeout
	idle()

## Override function
func get_acts() -> Array[Act]:
	var nothing := Act.new()
	nothing.title = "Do nothing"
	return [nothing]

## Override function
func get_spells() -> Array[Spell]:
	var nothing := Spell.new()
	nothing.title = "Nothing spell"
	nothing.tp_cost = 15
	return [nothing]

func idle() -> void:
	pass

func prep_attack() -> void:
	pass

func do_attack(p_monster: Monster, p_damage: int) -> void:
	p_monster.take_damage(self, p_damage)
	p_monster.damage_or_die_animation()

func hurt(p_damage: int) -> void:
	p_damage = int(maxi(1, p_damage - 3 * defense) * (1.0 if !defending else 2.0 / 3.0))
	current_hp -= p_damage
	health_changed.emit(current_hp)
	var new_text := preload("res://ui/battle/floating_text/floating_text.tscn").instantiate()
	new_text.initialize(global_position, str(p_damage), icon_color)
	get_tree().current_scene.add_child(new_text)
	if current_hp < 0:
		faint()

func faint() -> void:
	alive = false

func heal(p_amount: int) -> void:
	current_hp += p_amount
	var new_text := preload("res://ui/battle/floating_text/floating_text.tscn").instantiate()
	if !alive and current_hp > 0:
		revive()
	if current_hp >= max_hp:
		current_hp = max_hp
		new_text.initialize(global_position, "MAX", Global.GREEN)
	else:
		new_text.initialize(global_position, str(p_amount), icon_color)
	get_tree().current_scene.add_child(new_text)
	health_changed.emit(current_hp)

func revive() -> void:
	if current_hp < max_hp * 0.17:
		current_hp = ceili(max_hp * 0.17)
	alive = true
	idle()

func prep_act() -> void:
	pass

func do_act(_p_monster: Monster, _p_act: int) -> void:
	pass

func defend() -> void:
	defending = true
