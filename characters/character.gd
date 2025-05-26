extends Node2D
class_name Character

@export var title := ""
@export var current_hp := 100
@export var max_hp := 100
@export var strength := 100
@export var uses_magic := false
@export_color_no_alpha var main_color := Color.WHITE
@export_color_no_alpha var icon_color := Color.GRAY
@export var icon: Texture2D = preload("res://ui/battle/char_menu/res/sample_char_icon.png")

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
	p_monster.take_damage(p_damage)
	p_monster.damage_or_die_animation()

func prep_act() -> void:
	pass

func do_act(_p_monster: Monster, _p_act: int) -> void:
	pass

func defend() -> void:
	pass
