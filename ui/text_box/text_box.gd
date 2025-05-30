extends RichTextLabel

var require_input := false

static func is_letter_or_number(p_char: int) -> bool:
	var is_letter := (p_char >= 65 and p_char <= 90) or (p_char >= 97 and p_char <= 122)
	var is_number := p_char >= 48 and p_char <= 57
	return is_letter or is_number

func hide_text() -> void:
	visible_characters = 0
	Global.displaying_text = false

func show_text(p_text: String, p_requires_input: bool) -> void:
	text = p_text
	Global.displaying_text = true
	visible_characters = 0
	require_input = p_requires_input

func _ready() -> void:
	Global.display_text.connect(show_text)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("confirm") and event.is_pressed():
		if visible_ratio >= 1.0 and require_input and Global.displaying_text:
			Global.text_finished.emit()
			hide_text()

func _physics_process(_delta: float) -> void:
	if Global.displaying_text and visible_ratio < 1.0:
		visible_characters += 1
		var c := text[visible_characters - 1].to_ascii_buffer()[0]
		if is_letter_or_number(c):
			$TypingSound.play()
		if visible_ratio >= 1.0 and !require_input:
			Global.displaying_text = false
			Global.text_finished.emit()
