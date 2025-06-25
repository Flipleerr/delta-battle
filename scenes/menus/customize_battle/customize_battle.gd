extends Node2D

var dark_candy := preload("res://items/dark_candy.tres")
var blue_scene := preload("res://characters/blue/blue.tscn")
var slime_scene := preload("res://monsters/slime/slime.tscn")

var weapons: Array[Equippable] = [
	null,
	preload("res://equippables/weapons/wood_blade.tres"),
	preload("res://equippables/weapons/spooky_sword.tres")
]
var armors: Array[Equippable] = [
	null,
	preload("res://equippables/armors/amber_card.tres"),
	preload("res://equippables/armors/iron_shackle.tres"),
	preload("res://equippables/armors/white_ribbon.tres")
]

var do_focus_noise := true

func _ready() -> void:
	$Main/Start.grab_focus()
	$Heart.position = Vector2(90.0, $Main/Start.global_position.y + 48.0 / 2.0 + 2.0)
	Sounds.set_music("castletown", 0.8)
	get_viewport().gui_focus_changed.connect(on_focus_changed)
	
	for spin_box: CustomSpinBox in $Characters/VBox.get_children():
		spin_box.option = 1
	for spin_box: CustomSpinBox in $Enemies/VBox.get_children():
		spin_box.option = 1

func on_focus_changed(p_node: Control) -> void:
	$Heart.position = Vector2(90.0, p_node.global_position.y + 48.0 / 2.0 + 2.0)
	if do_focus_noise:
		Sounds.play("snd_menumove")

func _on_start_pressed() -> void:
	Sounds.play("snd_select")
	
	var weapon := weapons[$Equipment/VBox/Weapon.option]
	var armor: Array[Equippable] = []
	for spin_box: CustomSpinBox in [$Equipment/VBox/Armor1, $Equipment/VBox/Armor2]:
		var temp_armor := armors[spin_box.option]
		if temp_armor != null:
			armor.append(temp_armor)
	
	Global.characters.clear()
	for spin_box: CustomSpinBox in $Characters/VBox.get_children():
		var character: Character
		match spin_box.option:
			0:
				continue
			1:
				character = blue_scene.instantiate()
		Global.characters.append(character)
		character.weapon = weapon
		character.armors = armor
	if Global.characters.is_empty():
		Global.characters.append(blue_scene.instantiate())
	
	Global.monsters.clear()
	for spin_box: CustomSpinBox in $Enemies/VBox.get_children():
		var enemy: Monster
		match spin_box.option:
			0:
				continue
			1:
				enemy = slime_scene.instantiate()
		Global.monsters.append(enemy)
	if Global.monsters.is_empty():
		Global.monsters.append(slime_scene.instantiate())
	
	Global.items = [
		dark_candy, dark_candy, dark_candy, dark_candy, dark_candy, dark_candy, dark_candy, dark_candy
	]
	Global.change_to_scene("res://scenes/battle/battle.tscn")

func _on_back_pressed() -> void:
	Sounds.play("snd_select")
	$Characters.visible = false
	$Enemies.visible = false
	$Equipment.visible = false
	$Main.visible = true
	do_focus_noise = false
	$Main/Start.grab_focus()
	do_focus_noise = true

func _on_characters_pressed() -> void:
	Sounds.play("snd_select")
	$Main.visible = false
	$Characters.visible = true
	do_focus_noise = false
	$Characters/VBox/Char1.grab_focus()
	await get_tree().process_frame
	$Heart.position = Vector2(90.0, $Characters/VBox/Char1.global_position.y + 48.0 / 2.0 + 2.0)
	do_focus_noise = true

func _on_enemies_pressed() -> void:
	Sounds.play("snd_select")
	$Main.visible = false
	$Enemies.visible = true
	do_focus_noise = false
	$Enemies/VBox/Enemy1.grab_focus()
	await get_tree().process_frame
	$Heart.position = Vector2(90.0, $Enemies/VBox/Enemy1.global_position.y + 48.0 / 2.0 + 2.0)
	do_focus_noise = true

func _on_equipment_pressed() -> void:
	Sounds.play("snd_select")
	$Main.visible = false
	$Equipment.visible = true
	do_focus_noise = false
	$Equipment/VBox/Weapon.grab_focus()
	await get_tree().process_frame
	$Heart.position = Vector2(90.0, $Equipment/VBox/Weapon.global_position.y + 48.0 / 2.0 + 2.0)
	do_focus_noise = true
