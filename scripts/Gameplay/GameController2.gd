extends Node2D

@onready var center_container: Control = $Node2D/SubViewportContainer
@onready var center_model: Node3D = $Node2D/SubViewportContainer/SubViewport/CenterRoot
@onready var left_root: Node3D  = $Node2D2/SubViewportContainer/SubViewport/Node3D
@onready var right_root: Node3D = $Node2D3/SubViewportContainer/SubViewport/Node3D

var center_models = [
	{"scene":"res://scenes/models/rocket.tscn", "left_id":1, "right_id":2},
	{"scene":"res://scenes/models/earth.tscn",  "left_id":3, "right_id":4}
]

var side_parts = [
	{"scene":"res://scenes/parts/part1.tscn", "id":1},
	{"scene":"res://scenes/parts/part2.tscn", "id":2},
	{"scene":"res://scenes/parts/part3.tscn", "id":3},
	{"scene":"res://scenes/parts/part4.tscn", "id":4}
]

var current_index := 0

func _ready() -> void:
	add_to_group("game_controller")
	load_center_model()
	load_side_parts()

func is_point_over_center(global_point: Vector2) -> bool:
	return center_container.get_global_rect().has_point(global_point)

func try_attach_part(part_id: int) -> bool:
	# Пытаемся приложить к центру
	if center_model.try_attach(part_id):
		# Верная деталь: обновляем боковые детали сразу
		load_side_parts()

		# Если собрали обе стороны — переходим к следующей центральной модели
		if center_model.is_complete():
			current_index += 1
			if current_index < center_models.size():
				load_center_model()
				load_side_parts()
		return true
	return false

func load_center_model() -> void:
	var data = center_models[current_index]
	center_model.load_model(data["scene"], data["left_id"], data["right_id"])

func load_side_parts() -> void:
	for c in left_root.get_children():
		c.queue_free()
	for c in right_root.get_children():
		c.queue_free()

	var left_data  = side_parts[(current_index * 2)     % side_parts.size()]
	var right_data = side_parts[(current_index * 2 + 1) % side_parts.size()]

	var left_part  = load(left_data.scene).instantiate()
	var right_part = load(right_data.scene).instantiate()

	# у Part.gd есть экспортируемое поле part_id
	left_part.part_id  = left_data.id
	right_part.part_id = right_data.id

	left_root.add_child(left_part)
	right_root.add_child(right_part)
