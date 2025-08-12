extends Node2D

var start_position: Vector2
var dragging := false

func _ready():
	start_position = position

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
			else:
				dragging = false
				position = start_position  # Вернуть на место
	elif event is InputEventMouseMotion and dragging:
		position += event.relative
