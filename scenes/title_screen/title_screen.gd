extends Node2D

var dark_candy := preload("res://items/dark_candy.tres")
var blue_scene := preload("res://characters/blue/blue.tscn")
var slime_scene := preload("res://monsters/slime/slime.tscn")

func _ready() -> void:
	$Play.grab_focus()

func _on_play_focus_entered() -> void:
	$Heart.position = $Play.position + Vector2(-16.0, 48.0 / 2.0 + 2.0)

func _on_quit_focus_entered() -> void:
	$Heart.position = $Quit.position + Vector2(-16.0, 48.0 / 2.0 + 2.0)

func _on_play_pressed() -> void:
	Global.characters = [blue_scene.instantiate(), blue_scene.instantiate(), blue_scene.instantiate()]
	Global.monsters = [slime_scene.instantiate(), slime_scene.instantiate()]
	Global.items = [
		dark_candy, dark_candy, dark_candy, dark_candy, dark_candy, dark_candy, dark_candy, dark_candy
	]
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
