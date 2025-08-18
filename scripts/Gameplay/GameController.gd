extends Node2D

@export var center_controller_path: NodePath
@export var left_part_path: NodePath
@export var right_part_path: NodePath

# По имени центральной модели — ожидаемые ID боковых деталей
# Эти ID должны совпадать с тем, что вернёт DraggablePart.get_current_id()
@export var expected_ids := {
	"rocket": {"left": "rocket_left", "right": "rocket_right"},
	"earth":  {"left": "earth_left",  "right": "earth_right"}
}

@export var start_menu_scene: String = "res://start_menu.tscn"

var _center: Node3D
var _left: Node2D
var _right: Node2D

var _left_done := false
var _right_done := false

func _ready() -> void:
	_center = get_node(center_controller_path)
	_left = get_node(left_part_path)
	_right = get_node(right_part_path)
	# Сообщим боковым, какая модель сейчас активна (индекс 0)
	if _left.has_method("reset_to_model_index"):
		_left.reset_to_model_index(0)
	if _right.has_method("reset_to_model_index"):
		_right.reset_to_model_index(0)

func on_part_dropped(side: String, part_id: String) -> bool:
	# Проверка ID
	var center_name: String = _center.current_model.name
	var expected := expected_ids.get(center_name, {})
	var ok := (expected.get(side, "") == part_id)
	if not ok:
		return false

	# Открываем соответствующую половину
	_center.reveal_half(side)

	# Отмечаем выполненную сторону и скрываем её до окончания модели
	if side == "left":
		_left_done = true
		_left.hide_temporarily()
	else:
		_right_done = true
		_right.hide_temporarily()

	# Если обе половины собраны — переходим к следующей центральной модели
	if _left_done and _right_done:
		await get_tree().create_timer(0.6).timeout  # немного показать собранную модель
		var had_next := _center.next_model()
		_left_done = false
		_right_done = false

		if had_next:
			# Продвигаем обе боковые к следующему элементу очереди
			_left.advance_to_next_and_reset()
			_right.advance_to_next_and_reset()
			_left.show()
			_right.show()
		else:
			# Уровень завершён
			get_tree().change_scene_to_file(start_menu_scene)

	return true
