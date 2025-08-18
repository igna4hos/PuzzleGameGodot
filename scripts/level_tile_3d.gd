extends Button

@export var level_id: int = 1
@export_group("Background")
@export var background_size: Vector2 = Vector2(256, 232)
@export var background_color: Color = Color(0.2, 0.6, 1.0)  # Голубой цвет по умолчанию
@export var corner_radius: int = 128  # Радиус скругления углов (овальная форма)
@export_group("Model Configuration")
@export var tile_models: Resource  # Конфигурация моделей для этого тайла
@export_group("Rotation Animation")
@export var rotation_enabled: bool = true
@export var rotation_angle: float = 4.0  # Градусы поворота
@export var rotation_speed: float = 0.15   # Скорость анимации

@onready var world_node: Node3D = $Aspect/SubViewportContainer/SubViewport/World
var models_parent: Node3D  # Родительский объект для всех моделей (его мы будем анимировать)
var current_models: Array[Node3D] = []  # Массив загруженных моделей
@onready var circle_bg: Panel = $CircleBg
@onready var aspect: AspectRatioContainer = $Aspect
@onready var svc: SubViewportContainer = $Aspect/SubViewportContainer

func _ready() -> void:
	# Убираем рамку выделения
	focus_mode = Control.FOCUS_NONE
	
	# Обеспечиваем заполнение всей плитки и правильный прием кликов
	if aspect:
		aspect.set_anchors_preset(Control.PRESET_FULL_RECT)
	if svc:
		svc.set_anchors_preset(Control.PRESET_FULL_RECT)
		svc.stretch = true
	
	# Создаём прямоугольный фон после готовности
	call_deferred("_setup_background")
	# Загружаем модели после готовности
	call_deferred("_load_models")

var _is_pressed_in_circle: bool = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed:
				# При нажатии проверяем, попал ли в фон
				_is_pressed_in_circle = _is_point_in_background(mouse_event.position)
			else:
				# При отпускании проверяем touchUpInside логику
				if _is_pressed_in_circle and _is_point_in_background(mouse_event.position):
					# Эмулируем нажатие кнопки только если начали и закончили в фоне
					pressed.emit()
				_is_pressed_in_circle = false

func _is_point_in_background(point: Vector2) -> bool:
	if not circle_bg:
		return false
	
	# Получаем прямоугольную область фона
	var bg_rect = circle_bg.get_rect()
	
	# Проверяем, попадает ли точка в прямоугольник
	return bg_rect.has_point(point)

func _setup_background() -> void:
	if circle_bg:
		# Устанавливаем размер фона
		circle_bg.custom_minimum_size = background_size
		circle_bg.size = background_size
		
		# Создаём стиль с заданным цветом и скруглением
		var style_box := StyleBoxFlat.new()
		style_box.bg_color = background_color
		
		# Применяем скругление углов
		style_box.corner_radius_top_left = corner_radius
		style_box.corner_radius_top_right = corner_radius
		style_box.corner_radius_bottom_left = corner_radius
		style_box.corner_radius_bottom_right = corner_radius
		
		# Включаем сглаживание для мягких углов
		style_box.anti_aliasing = true
		style_box.anti_aliasing_size = 2.0
		
		# Убираем границы
		style_box.border_width_left = 0
		style_box.border_width_right = 0
		style_box.border_width_top = 0
		style_box.border_width_bottom = 0
		
		# Для Panel используем "panel" override
		circle_bg.add_theme_stylebox_override("panel", style_box)
		print("Applied background to tile ", level_id, " size: ", background_size, " color: ", background_color)

var rotation_direction: int = 1  # 1 для вправо, -1 для влево
var current_rotation: float = 0.0

func _process(delta: float) -> void:
	if is_visible_in_tree() and rotation_enabled and models_parent:
		# Анимация поворота влево-вправо родительского объекта
		var target_rotation = rotation_direction * deg_to_rad(rotation_angle)
		current_rotation = move_toward(current_rotation, target_rotation, rotation_speed * delta)
		
		# Применяем поворот к родительскому объекту
		models_parent.rotation.y = current_rotation
		
		# Меняем направление при достижении цели
		if abs(current_rotation - target_rotation) < 0.01:
			rotation_direction *= -1

## Загрузка моделей согласно конфигурации тайла
func _load_models() -> void:
	# Очищаем старые модели
	_clear_models()
	
	if not tile_models:
		print("No tile models configuration set for tile ", level_id)
		return
	
	# Создаём родительский объект для моделей
	models_parent = Node3D.new()
	models_parent.name = "ModelsParent"
	world_node.add_child(models_parent)
	
	# Загружаем все модели из конфигурации
	var model_count = tile_models.get_model_count() if tile_models.has_method("get_model_count") else 0
	
	for i in range(model_count):
		var model_data = tile_models.get_model_data(i) if tile_models.has_method("get_model_data") else {}
		if not model_data.is_empty():
			_load_single_model(model_data)

## Загрузка одной модели
func _load_single_model(model_data: Dictionary) -> void:
	var model_path = model_data.get("path", "")
	if model_path.is_empty():
		return
	
	# Загружаем модель
	var model_scene = load(model_path)
	if not model_scene:
		print("Failed to load model: ", model_path)
		return
	
	var model_instance = model_scene.instantiate()
	if not model_instance:
		print("Failed to instantiate model: ", model_path)
		return
	
	# Применяем настройки из конфигурации
	model_instance.position = model_data.get("position", Vector3.ZERO)
	model_instance.rotation_degrees = model_data.get("rotation", Vector3.ZERO)
	model_instance.scale = model_data.get("scale", Vector3.ONE)
	
	# Добавляем к родительскому объекту
	models_parent.add_child(model_instance)
	current_models.append(model_instance)
	
	print("Loaded model: ", model_path, " for tile ", level_id)

## Очистка всех загруженных моделей
func _clear_models() -> void:
	# Удаляем родительский объект со всеми моделями
	if models_parent and is_instance_valid(models_parent):
		models_parent.queue_free()
		models_parent = null
	
	current_models.clear()

## Смена конфигурации моделей
func set_tile_models(new_config: Resource) -> void:
	tile_models = new_config
	_load_models()
