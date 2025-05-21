extends Control
class_name TwoColItem

var title := ""
var description := ""

func initialize(p_title: String, p_description := "") -> void:
	title = p_title
	description = p_description
	$Label.text = title

func set_select(p_select: bool) -> void:
	$Heart.visible = p_select
