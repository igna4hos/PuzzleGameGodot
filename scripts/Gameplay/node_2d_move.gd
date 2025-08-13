extends Node2D

@onready var connector_controller: Node3D = $SubViewportContainer/SubViewport/Node3D
@onready var anim_player: AnimationPlayer = connector_controller.get_node("EasyRotationAnimation")

var dragging := false
var start_position: Vector2
#var original_scale: Vector3

func _ready():
	start_position = global_position
	#original_scale = connector_controller.scale
	anim_player.play("easy_rotation")

func _input(event):
	# Нажатие
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			if _is_event_on_object(event.position):
				dragging = true
				_play_scale_move()
		else:
			# Отпускание
			if dragging:
				dragging = false
				_check_center_or_reset()
				_play_easy_rotation()

	# Перетаскивание
	if event is InputEventScreenDrag or event is InputEventMouseMotion:
		if dragging:
			global_position = event.position

func _is_event_on_object(point: Vector2) -> bool:
	# Если есть спрайт-потомок — используем его границы
	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		return sprite.get_rect().has_point(sprite.to_local(point))
	
	# Если нет — используем примерный прямоугольник вокруг позиции объекта
	var size = Vector2(300, 300) # Подбери под твой объект
	var rect = Rect2(-size/2, size)
	return rect.has_point(to_local(point))

func _check_center_or_reset():
	global_position = start_position
	#connector_controller.scale = original_scale
	
func _play_scale_move():
	anim_player.stop()
	anim_player.play("scale_move")
	anim_player.advance(anim_player.current_animation_length) # Заморозка в конце
	
func _play_easy_rotation():
	anim_player.stop()
	anim_player.play("easy_rotation")
