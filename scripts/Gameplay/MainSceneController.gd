extends Node2D

@onready var center_model: Node3D = $CentralElementPart/SubViewportContainer/SubViewport/CentralElement
@onready var left_root: Node3D  = $LeftElementPart/SubViewportContainer/SubViewport/LeftElement

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
	load_center_model()
	load_side_parts()
	await get_tree().create_timer(5.0).timeout
	_next_model()

func load_center_model() -> void:
	var data = center_models[current_index]
	center_model.load_model(data["scene"], data["left_id"], data["right_id"])

func load_side_parts() -> void:
	for c in left_root.get_children():
		c.queue_free()

	var left_data  = side_parts[(current_index * 2)     % side_parts.size()]

	var left_part  = load(left_data.scene).instantiate()
	
	print("part.id before, ", left_part.part_id)
	# у Part.gd есть экспортируемое поле part_id
	left_part.part_id  = left_data.id
	print("left_data.id before, ", left_data.id)

	left_root.add_child(left_part)

func _next_model() -> void:
	current_index += 1
	if current_index >= center_models.size():
		current_index = 0
	load_center_model()
	load_side_parts()
