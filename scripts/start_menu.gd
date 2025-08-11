extends Node2D

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/puzzle_gameplay.tscn")
