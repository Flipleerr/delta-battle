extends Node2D

var activated := false

func _ready() -> void:
	$CharMenu.set_main_color(Color.AQUA)

func _input(event: InputEvent) -> void:
	if event.is_action("confirm") and event.is_pressed():
		if !activated:
			$CharMenu.activate()
			activated = true
		else:
			$CharMenu.deactivate()
			activated = false
