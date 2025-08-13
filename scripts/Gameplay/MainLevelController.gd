extends Node2D

func _on_exit_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
