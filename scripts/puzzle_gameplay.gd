extends Node2D

# Левые детали
var parts_queue = [
	{
		"left":  { "texture": "res://assets/sprites/left_parts/LeftPart_Car_1.png",  "is_correct": true },
		"right": { "texture": "res://assets/sprites/right_parts/RightPart_Car_1.png", "is_correct": false }
	},
	{
		"left":  { "texture": "res://assets/sprites/left_parts/LeftPart_Car_2.png",  "is_correct": false },
		"right": { "texture": "res://assets/sprites/right_parts/RightPart_Car_2.png", "is_correct": true }
	}
] 

var current_index = 0
var collected_parts = 0
var current_model_index = 1
var total_models = 1

func _ready():
	_load_side_parts()

func _load_side_parts():
	var data = parts_queue[current_model_index - 1] # так как index начинается с 1

	var left_sprite = $LeftPart
	left_sprite.texture = load(data.left.texture)
	left_sprite.set_meta("is_correct", data.left.is_correct)

	var right_sprite = $RightPart
	right_sprite.texture = load(data.right.texture)
	right_sprite.set_meta("is_correct", data.right.is_correct)

func on_correct_part_delivered(part: Sprite2D):
	collected_parts += 1

	if collected_parts == 1:
		# Вторая стадия центральной модели
		$CenterModel.texture = load("res://assets/sprites/center_models/CenterModel_Car_%d_2.png" % current_model_index)
	elif collected_parts == 2:
		# Полностью собранная модель
		$CenterModel.texture = load("res://assets/sprites/center_models/CenterModel_Car_%d_3.png" % current_model_index)

		# Скрываем части, ждём, потом следующая модель
		$LeftPart.hide()
		$RightPart.hide()
		await get_tree().create_timer(1.0).timeout

		current_model_index += 1
		if current_model_index > total_models:
			get_tree().change_scene_to_file("res://start_menu.tscn")
		else:
			collected_parts = 0
			$CenterModel.texture = load("res://assets/sprites/center_models/CenterModel_Car_%d_1.png" % current_model_index)

			current_index += 1
			_load_side_parts()

			$LeftPart.show()
			$RightPart.show()
