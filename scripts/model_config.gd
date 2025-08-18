class_name TileModelConfig
extends Resource

## Конфигурация моделей для тайла (только целые модели)
@export_group("Tile Settings")
@export var tile_name: String = ""  # Название тайла (например "Машина")
@export var theme_folder: String = "cars"  # Папка темы в res://assets/ModelsObject/

@export_group("Models")
@export var model_paths: Array[String] = []  # Пути к моделям
@export var model_positions: Array[Vector3] = []  # Позиции моделей
@export var model_rotations: Array[Vector3] = []  # Повороты моделей (в градусах)
@export var model_scales: Array[Vector3] = []  # Масштабы моделей
@export var model_names: Array[String] = []  # Названия моделей

## Добавить модель в композицию
func add_model(path: String, pos: Vector3 = Vector3.ZERO, rot: Vector3 = Vector3.ZERO, scl: Vector3 = Vector3.ONE, name: String = "") -> void:
	model_paths.append(path)
	model_positions.append(pos)
	model_rotations.append(rot)
	model_scales.append(scl)
	model_names.append(name)

## Получить количество моделей
func get_model_count() -> int:
	return model_paths.size()

## Получить данные модели по индексу
func get_model_data(index: int) -> Dictionary:
	if index < 0 or index >= get_model_count():
		return {}
	
	return {
		"path": model_paths[index],
		"position": model_positions[index] if index < model_positions.size() else Vector3.ZERO,
		"rotation": model_rotations[index] if index < model_rotations.size() else Vector3.ZERO,
		"scale": model_scales[index] if index < model_scales.size() else Vector3.ONE,
		"name": model_names[index] if index < model_names.size() else ""
	}
