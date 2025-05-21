extends Monster
class_name Slime

func get_opening_line() -> String:
	for monster: Monster in Global.monsters:
		if monster == self:
			continue
		if monster is Slime:
			return "  * The slimes bounced into battle!"
	return "  * A slime bounced into battle!"
