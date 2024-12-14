extends Node


func _ready():
	# $Player.health_changed.connect($HealthUI.update_hearts)
	pass

func _process(delta: float) -> void:
	change_scene()


func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "interlude":
			get_tree().change_scene_to_file("res://scenes/world_2.tscn")
			global.finish_change_scene()



func _on_world_2_transition_body_exited(body:Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false


func _on_world_2_transition_body_entered(body:Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true

