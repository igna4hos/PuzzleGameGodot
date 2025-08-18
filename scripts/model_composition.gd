class_name ModelComposition
extends Resource

## Композиция из нескольких моделей для тайла
@export_group("Composition Info")
@export var composition_name: String = ""  # Название композиции (например "Машина")
@export var theme_folder: String = "cars"  # Папка темы в res://assets/ModelsObject/

@export_group("Models")
@export var whole_model: Resource  # Целая модель
@export var left_half: Resource    # Левая половинка
@export var right_half: Resource   # Правая половинка

@export_group("Animation Settings")
@export var use_custom_animation: bool = false
@export var custom_rotation_angle: float = 30.0
@export var custom_rotation_speed: float = 1.0

func _init():
	# Инициализируем пустые конфигурации
	if not whole_model:
		whole_model = preload("res://scripts/model_config.gd").new()
	if not left_half:
		left_half = preload("res://scripts/model_config.gd").new()
	if not right_half:
		right_half = preload("res://scripts/model_config.gd").new()

## Быстрая настройка для темы машин
func setup_cars_theme():
	composition_name = "Машина"
	theme_folder = "cars"
	
	# Пример настройки (пути нужно будет скорректировать под ваши файлы)
	var ModelConfigClass = preload("res://scripts/model_config.gd")
	
	# Создаём конфигурацию для целой модели
	whole_model = ModelConfigClass.new()
	whole_model.tile_name = "Целая машина"
	whole_model.theme_folder = "cars"
	whole_model.add_model("res://assets/ModelsObject/cars/car.glb", Vector3.ZERO, Vector3.ZERO, Vector3.ONE, "Целая машина")
	
	# Создаём конфигурацию для левой половины
	left_half = ModelConfigClass.new()
	left_half.tile_name = "Левая половина"
	left_half.theme_folder = "cars"
	left_half.add_model("res://assets/ModelsObject/cars/car_left.glb", Vector3(-0.5, 0, 0), Vector3.ZERO, Vector3.ONE, "Левая половина")
	
	# Создаём конфигурацию для правой половины
	right_half = ModelConfigClass.new()
	right_half.tile_name = "Правая половина"
	right_half.theme_folder = "cars"
	right_half.add_model("res://assets/ModelsObject/cars/car_right.glb", Vector3(0.5, 0, 0), Vector3.ZERO, Vector3.ONE, "Правая половина")
