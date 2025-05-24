extends Node2D
class_name Monster

@export var title := ""
@export var current_hp := 100
@export var max_hp := 100

@export_node_path("Sprite2D") var main_sprite
var sprite: Sprite2D

func _ready() -> void:
	if !main_sprite:
		return
	sprite = get_node(main_sprite)
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://monsters/generic_monster.gdshader")
	sprite.material = mat

func get_opening_line() -> String:
	return ""

func set_selected(p_selected: bool) -> void:
	if !sprite:
		return
	sprite.material.set_shader_parameter("flash", float(p_selected))
