extends Node2D

func _ready() -> void:
	var num_characters := Global.characters.size()
	if num_characters == 1:
		var character := Global.characters[0]
		$Characters.add_child(character)
		character.position = Vector2(108.0, 171.0)
	elif num_characters == 2:
		var character_1 := Global.characters[0]
		var character_2 := Global.characters[1]
		$Characters.add_child(character_1)
		$Characters.add_child(character_2)
		character_1.position = Vector2(108.0, 171.0 - 48.0)
		character_2.position = Vector2(108.0, 171.0 + 96.0 - 48.0)
	else:
		for i: int in num_characters:
			var character := Global.characters[i]
			$Characters.add_child(character)
			character.position.x = 108.0
			character.position.y = 171.0 - 96.0 + 2.0 * 96.0 * i / (num_characters - 1)
