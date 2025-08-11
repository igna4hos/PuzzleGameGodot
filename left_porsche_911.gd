extends Sprite2D

var dragging := false
var start_position: Vector2

func _ready():
	start_position = global_position

func _input(event):
	# Нажатие
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			if get_rect().has_point(to_local(event.position)):
				dragging = true
		else:
			# Отпускание
			if dragging:
				dragging = false
				_check_center_or_reset()

	# Перетаскивание
	if event is InputEventScreenDrag or event is InputEventMouseMotion:
		if dragging:
			global_position = event.position

func _check_center_or_reset():
	global_position = start_position
