extends Node2D

var dark_candy := preload("res://items/dark_candy.tres")
var blue_scene := preload("res://characters/blue/blue.tscn")
var slime_scene := preload("res://monsters/slime/slime.tscn")

func _ready() -> void:
	$Play.grab_focus()
	Sounds.set_music("fanfare", 0.8, false)

func _on_play_focus_entered() -> void:
	$Heart.position = $Play.position + Vector2(-16.0, 48.0 / 2.0 + 2.0)
	Sounds.play("snd_menumove")

func _on_quit_focus_entered() -> void:
	$Heart.position = $Quit.position + Vector2(-16.0, 48.0 / 2.0 + 2.0)
	Sounds.play("snd_menumove")

func _on_play_pressed() -> void:
	Sounds.play("snd_select")
	Global.characters = [blue_scene.instantiate(), blue_scene.instantiate(), blue_scene.instantiate()]
	Global.monsters = [slime_scene.instantiate(), slime_scene.instantiate()]
	Global.items = [
		dark_candy, dark_candy, dark_candy, dark_candy, dark_candy, dark_candy, dark_candy, dark_candy
	]
	Global.change_to_scene("res://scenes/battle/battle.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
