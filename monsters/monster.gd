extends Node2D
class_name Monster

@export var title := ""
@export var current_hp := 100
@export var max_hp := 100
@export var strength := 0
@export var defense := 0

@export_node_path("Sprite2D") var main_sprite
var sprite: Sprite2D
var mat: ShaderMaterial
var dying := false

signal health_changed(p_new_health: float)

func _ready() -> void:
	if !main_sprite:
		return
	sprite = get_node(main_sprite)
	mat = ShaderMaterial.new()
	mat.shader = preload("res://monsters/generic_monster.gdshader")
	sprite.material = mat

func get_opening_line() -> String:
	return ""

func set_selected(p_selected: bool) -> void:
	if !mat:
		return
	mat.set_shader_parameter("flash", float(p_selected))

func damage_or_die_animation() -> void:
	if dying:
		queue_free()

func take_damage(p_character: Character, p_damage: int) -> void:
	current_hp -= (p_damage - defense * 3)
	health_changed.emit(current_hp)
	var new_text := preload("res://ui/battle/floating_text/floating_text.tscn").instantiate()
	new_text.initialize(global_position, str(p_damage) if p_damage > 0 else "MISS", p_character.icon_color)
	get_tree().current_scene.add_child(new_text)
	if current_hp < 0:
		dying = true
		Global.kill_monster(self)
