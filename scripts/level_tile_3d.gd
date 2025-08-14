extends Button

@export var level_id: int = 1
@export var rotation_speed: float = 1.2

@onready var cube: Node3D = $Aspect/SubViewportContainer/SubViewport/World/Cube
@onready var label: Label = $Label
@onready var aspect: AspectRatioContainer = $Aspect
@onready var svc: SubViewportContainer = $Aspect/SubViewportContainer

func _ready() -> void:
	# Обеспечиваем заполнение всей плитки и правильный прием кликов
	if aspect:
		aspect.set_anchors_preset(Control.PRESET_FULL_RECT)
	if svc:
		svc.set_anchors_preset(Control.PRESET_FULL_RECT)
		svc.stretch = true
	if label:
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	if is_visible_in_tree() and cube:
		cube.rotate_y(rotation_speed * delta)
