class_name ModelComposition
extends Resource

## Composition of multiple models for a tile
@export_group("Composition Info")
@export var composition_name: String = ""  # Composition name (e.g. "Car")
@export var theme_folder: String = "cars"  # Theme folder under res://assets/ModelsObject/

@export_group("Models")
@export var whole_model: Resource  # Whole model
@export var left_half: Resource    # Left half
@export var right_half: Resource   # Right half

@export_group("Animation Settings")
@export var use_custom_animation: bool = false
@export var custom_rotation_angle: float = 30.0
@export var custom_rotation_speed: float = 1.0

func _init():
	# Initialize empty configurations
	if not whole_model:
		whole_model = preload("res://scripts/model_config.gd").new()
	if not left_half:
		left_half = preload("res://scripts/model_config.gd").new()
	if not right_half:
		right_half = preload("res://scripts/model_config.gd").new()

## Quick setup for the cars theme
func setup_cars_theme():
	composition_name = "Car"
	theme_folder = "cars"
	
	# Example setup (adjust paths to match your files)
	var ModelConfigClass = preload("res://scripts/model_config.gd")
	
	# Create configuration for the whole model
	whole_model = ModelConfigClass.new()
	whole_model.tile_name = "Whole car"
	whole_model.theme_folder = "cars"
	whole_model.add_model("res://assets/ModelsObject/cars/car.glb", Vector3.ZERO, Vector3.ZERO, Vector3.ONE, "Whole car")
	
	# Create configuration for the left half
	left_half = ModelConfigClass.new()
	left_half.tile_name = "Left half"
	left_half.theme_folder = "cars"
	left_half.add_model("res://assets/ModelsObject/cars/car_left.glb", Vector3(-0.5, 0, 0), Vector3.ZERO, Vector3.ONE, "Left half")
	
	# Create configuration for the right half
	right_half = ModelConfigClass.new()
	right_half.tile_name = "Right half"
	right_half.theme_folder = "cars"
	right_half.add_model("res://assets/ModelsObject/cars/car_right.glb", Vector3(0.5, 0, 0), Vector3.ZERO, Vector3.ONE, "Right half")
