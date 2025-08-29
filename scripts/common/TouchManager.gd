extends Node

var active_touch_id: int = -1
var is_touch_active: bool = false

func can_process_touch(touch_index: int) -> bool:
	if not is_touch_active:
		active_touch_id = touch_index
		is_touch_active = true
		return true
	return touch_index == active_touch_id

func release_touch(touch_index: int) -> void:
	if touch_index == active_touch_id:
		active_touch_id = -1
		is_touch_active = false
