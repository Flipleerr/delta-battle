extends Resource
class_name Act

var title := ""

## Override function
func do_act(_from: Character):
	pass

func _init(p_title: String) -> void:
	title = p_title
