extends Node


func _ready():
	# $Player.health_changed.connect($HealthUI.update_hearts)
	pass

func _process(delta: float) -> void:
	change_scene()

func _on_interlude_transition_body_shape_entered(body_rid:RID, body:Node2D, body_shape_index:int, local_shape_index:int) -> void:
	if body.has_method("player"):
		global.transition_scene = true

func _on_interlude_transition_body_shape_exited(body_rid:RID, body:Node2D, body_shape_index:int, local_shape_index:int) -> void:
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/interlude_scene.tscn")
			global.finish_change_scene()
