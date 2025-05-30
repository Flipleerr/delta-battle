extends Node2D
class_name Monster

@export var title := ""
@export_multiline var description := ""
@export var current_hp := 100
@export var max_hp := 100
@export var strength := 0
@export var defense := 0

@export_node_path("Sprite2D") var main_sprite
var sprite: Sprite2D
var mat: ShaderMaterial
var dying := false
var mercy_percent := 0.0

signal health_changed(p_new_health: float)
signal mercy_changed(p_new_mercy: float)
signal exit_finished
signal attack_finished

func _ready() -> void:
	if !main_sprite:
		return
	sprite = get_node(main_sprite)
	mat = ShaderMaterial.new()
	mat.shader = preload("res://monsters/generic_monster.gdshader")
	sprite.material = mat

func get_opening_line() -> String:
	return ""

func get_idle_line() -> String:
	return ""

func set_selected(p_selected: bool) -> void:
	if !mat:
		return
	mat.set_shader_parameter("flash", float(p_selected))

func damage_or_die_animation() -> void:
	if dying:
		exit_finished.emit()
		queue_free()

func take_damage(p_character: Character, p_damage: int) -> void:
	current_hp -= (p_damage - defense * 3)
	health_changed.emit(current_hp)
	create_text(str(p_damage) if p_damage > 0 else "MISS", p_character.icon_color)
	if current_hp < 0:
		dying = true
		Global.delete_monster(self)

func increase_mercy(p_amount: float) -> void:
	p_amount = minf(p_amount, 1.0 - mercy_percent)
	mercy_percent = minf(1.0, mercy_percent + p_amount)
	create_text("+" + str(int(100.0 * p_amount)) + "%", Global.YELLOW)
	mercy_changed.emit(mercy_percent)

func create_text(p_text: String, p_color: Color) -> void:
	var new_text := preload("res://ui/battle/floating_text/floating_text.tscn").instantiate()
	new_text.initialize(global_position, p_text, p_color)
	get_tree().current_scene.add_child(new_text)

func spare() -> void:
	Global.delete_monster(self)
	exit_finished.emit()
	queue_free()

func do_attack() -> void:
	await get_tree().create_timer(0.01).timeout
	attack_finished.emit()
