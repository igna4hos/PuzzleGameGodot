extends Node

var selected_level: int = 1

var model_kits := {
	1: {
		"center_models": [
			{"scene":"res://assets/ModelsObject/cars/scooter.glb", "left_id":1, "right_id":2},
			{"scene":"res://assets/ModelsObject/cars/panzer.glb", "left_id":3, "right_id":4},
			{"scene":"res://assets/ModelsObject/cars/train.glb", "left_id":5, "right_id":6},
			{"scene":"res://assets/ModelsObject/cars/bike.glb", "left_id":7, "right_id":8},
			{"scene":"res://assets/ModelsObject/cars/car.glb", "left_id":9, "right_id":10}
		],
		"side_parts": [
			{"scene":"res://assets/ModelsObject/cars/scooter_left.glb", "id":1},
			{"scene":"res://assets/ModelsObject/cars/panzer_left.glb", "id":3},
			{"scene":"res://assets/ModelsObject/cars/train_left.glb", "id":5},
			{"scene":"res://assets/ModelsObject/cars/scooter_right.glb", "id":2},
			{"scene":"res://assets/ModelsObject/cars/car_right.glb", "id":10},
			{"scene":"res://assets/ModelsObject/cars/panzer_left.glb", "id":3},
			{"scene":"res://assets/ModelsObject/cars/panzer_right.glb", "id":4},
			{"scene":"res://assets/ModelsObject/cars/bike_right.glb", "id":8},
			{"scene":"res://assets/ModelsObject/cars/train_left.glb", "id":5},
			{"scene":"res://assets/ModelsObject/cars/car_left.glb", "id":9},
			{"scene":"res://assets/ModelsObject/cars/bike_left.glb", "id":7},
			{"scene":"res://assets/ModelsObject/cars/train_right.glb", "id":6},
			{"scene":"res://assets/ModelsObject/cars/bike_left.glb", "id":7},
			{"scene":"res://assets/ModelsObject/cars/scooter_right.glb", "id":2},
			{"scene":"res://assets/ModelsObject/cars/panzer_right.glb", "id":4},
			{"scene":"res://assets/ModelsObject/cars/bike_right.glb", "id":8},
			{"scene":"res://assets/ModelsObject/cars/car_right.glb", "id":10},
			{"scene":"res://assets/ModelsObject/cars/train_right.glb", "id":6},
			{"scene":"res://assets/ModelsObject/cars/scooter_left.glb", "id":1},
			{"scene":"res://assets/ModelsObject/cars/car_left.glb", "id":9}
		]
	},

	2: {
		"center_models": [
			{"scene":"res://assets/ModelsObject/insects/bee.glb", "left_id":11, "right_id":12},
			{"scene":"res://assets/ModelsObject/insects/butterfly.glb", "left_id":13, "right_id":14},
			{"scene":"res://assets/ModelsObject/insects/ant.glb", "left_id":15, "right_id":16},
			{"scene":"res://assets/ModelsObject/insects/dragonfly.glb", "left_id":17, "right_id":18},
			{"scene":"res://assets/ModelsObject/insects/ladybug.glb", "left_id":19, "right_id":20}
		],
		"side_parts": [
			{"scene":"res://assets/ModelsObject/insects/ant_right.glb", "id":16},
			{"scene":"res://assets/ModelsObject/insects/bee_right.glb", "id":12},
			{"scene":"res://assets/ModelsObject/insects/bee_left.glb", "id":11},
			{"scene":"res://assets/ModelsObject/insects/dragonfly_left.glb", "id":17},
			{"scene":"res://assets/ModelsObject/insects/butterfly_right.glb", "id":14},
			{"scene":"res://assets/ModelsObject/insects/ladybug_right.glb", "id":20},
			{"scene":"res://assets/ModelsObject/insects/bee_left.glb", "id":11},
			{"scene":"res://assets/ModelsObject/insects/butterfly_left.glb", "id":13},
			{"scene":"res://assets/ModelsObject/insects/butterfly_right.glb", "id":14},
			{"scene":"res://assets/ModelsObject/insects/ant_left.glb", "id":15},
			{"scene":"res://assets/ModelsObject/insects/ant_right.glb", "id":16},
			{"scene":"res://assets/ModelsObject/insects/dragonfly_right.glb", "id":18},
			{"scene":"res://assets/ModelsObject/insects/dragonfly_right.glb", "id":18},
			{"scene":"res://assets/ModelsObject/insects/butterfly_left.glb", "id":13},
			{"scene":"res://assets/ModelsObject/insects/ladybug_left.glb", "id":19},
			{"scene":"res://assets/ModelsObject/insects/dragonfly_left.glb", "id":17},
			{"scene":"res://assets/ModelsObject/insects/ladybug_left.glb", "id":19},
			{"scene":"res://assets/ModelsObject/insects/ant_left.glb", "id":15},
			{"scene":"res://assets/ModelsObject/insects/bee_right.glb", "id":12},
			{"scene":"res://assets/ModelsObject/insects/ladybug_right.glb", "id":20}
		]
	}
}
