extends Control


func _on_button_pressed() -> void:
	print("button pressed")
	get_tree().change_scene_to_file("res://scenes/world.tscn")
