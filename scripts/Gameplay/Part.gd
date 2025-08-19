extends Node2D

@export var part_id: int = -1
@export var game_controller_path: NodePath   # опционально, можно оставить пустым

var dragging := false
var start_pos: Vector2
var last_pointer_pos: Vector2
var _controller: Node = null

func _ready() -> void:
	start_pos = global_position
	# Попробуем взять контроллер по пути (если задан)
	if game_controller_path != NodePath():
		_controller = get_node_or_null(game_controller_path)

func _unhandled_input(event: InputEvent) -> void:
	# --- Тач ---
	if event is InputEventScreenTouch:
		last_pointer_pos = event.position
		if event.pressed:
			if _is_event_on_object(event.position):
				dragging = true
		else:
			if dragging:
				dragging = false
				_on_drop(event.position)

	elif event is InputEventScreenDrag:
		last_pointer_pos = event.position
		if dragging:
			global_position = event.position

	# --- Мышь ---
	elif event is InputEventMouseButton:
		last_pointer_pos = event.position
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if _is_event_on_object(event.position):
					dragging = true
			else:
				if dragging:
					dragging = false
					_on_drop(event.position)

	elif event is InputEventMouseMotion:
		last_pointer_pos = event.position
		if dragging:
			global_position = event.position

func _on_drop(point: Vector2) -> void:
	var game_controller = _get_game_controller()
	if not game_controller:
		_reset_position()
		return

	if game_controller.is_point_over_center(point):
		if game_controller.try_attach_part(part_id):
			queue_free() # верная деталь "прикрепилась"
			return

	# не попали или неверная деталь
	_reset_position()

func _reset_position() -> void:
	global_position = start_pos

func _is_event_on_object(point: Vector2) -> bool:
	var sprite: Sprite2D = get_node_or_null("Sprite2D")
	if sprite:
		return sprite.get_rect().has_point(sprite.to_local(point))
	return Rect2(-Vector2(200,200)/2, Vector2(200,200)).has_point(to_local(point))

func _get_game_controller() -> Node:
	if _controller:
		return _controller
	# запасной способ — через группу
	return get_tree().get_first_node_in_group("game_controller")
