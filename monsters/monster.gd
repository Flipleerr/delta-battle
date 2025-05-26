extends Node2D
class_name Monster

@export var title := ""
@export var current_hp := 100
@export var max_hp := 100

@export_node_path("Sprite2D") var main_sprite
var sprite: Sprite2D
var mat: ShaderMaterial
var last_damage: int
var dying := false

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

func take_damage(p_damage: int) -> void:
	current_hp -= p_damage
	last_damage = p_damage
	if current_hp < 0:
		dying = true
		Global.kill_monster(self)
