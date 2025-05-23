extends RichTextLabel

signal text_finished
var showing := false

static func is_letter_or_number(c: int) -> bool:
	var is_letter := (c >= 65 and c <= 90) or (c >= 97 and c <= 122)
	var is_number := c >= 48 and c <= 57
	return is_letter or is_number

func hide_text() -> void:
	showing = false
	visible_characters = 0

func show_text() -> void:
	showing = true
	visible_characters = 0

func _physics_process(_delta: float) -> void:
	if showing and visible_ratio != 1.0:
		visible_characters += 1
		var c := text[visible_characters - 1].to_ascii_buffer()[0]
		if is_letter_or_number(c):
			$TypingSound.play()
		if visible_ratio >= 1.0:
			text_finished.emit()
