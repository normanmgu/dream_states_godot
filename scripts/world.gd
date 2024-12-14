extends Node


@onready var transition_collision = $interlude_transition/CollisionShape2D
var enemies_remaining: int = 0

func _ready():
	transition_collision.disabled = true
	# $Player.health_changed.connect($HealthUI.update_hearts)
	var enemy_parent = $"y-sort-objects/"
	for node in enemy_parent.get_children():
		if node.name.begins_with("slime"):
			node.enemy_died.connect(_on_enemy_defeated)
			enemies_remaining += 1
	print("Initial enemies: ", enemies_remaining)

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

func _on_enemy_defeated():
	enemies_remaining -= 1
	print("Enemy defeated! Remaining: ", enemies_remaining)
	if enemies_remaining <= 0:
		print("All enemies defeated! Enabling transition...")
		transition_collision.disabled = false