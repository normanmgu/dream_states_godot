extends Control

@onready var hearts_container = $HeartContainer
var pHeartIcon := preload("res://HUD/HeartIcon.tscn")
var pEmptyIcon := preload("res://HUD/EmptyHeartIcon.tscn")
var pHalfIcon := preload("res://HUD/HalfHeartIcon.tscn")

func _ready():
	# connect to signal
	global.health_changed.connect(_on_player_health_changed)

	if !hearts_container:
		push_error("HeartContainer node not found!")
		return
	# Set it to take up full viewport
	anchors_preset = Control.PRESET_FULL_RECT
	# Set position relative to top-left
	#position = Vector2(-160, -100)
	position = Vector2.ZERO
	# Configure the hearts container
	hearts_container.position = Vector2.ZERO
	hearts_container.custom_minimum_size = Vector2(100, 100)
	# clearLives()

func clearLives():
	for child in hearts_container.get_children():
		hearts_container.remove_child(child)

func setHearts(heart_count: int):
	clearLives()
	for i in range(heart_count):
		hearts_container.add_child(pHeartIcon.instantiate())
	hearts_container.add_child(pEmptyIcon.instantiate())
	hearts_container.add_child(pHalfIcon.instantiate())

func _on_player_health_changed(current_health: float, max_health: int):
	clearLives()
	
	# Calculate number of full hearts
	var full_hearts = floor(current_health)
	
	# Calculate if we need a half heart
	var need_half_heart = (current_health - full_hearts) >= 0.5
	
	# Calculate empty hearts
	var empty_hearts = max_health - ceil(current_health)
	
	# Add full hearts
	for i in range(full_hearts):
		hearts_container.add_child(pHeartIcon.instantiate())
	
	# Add half heart if needed
	if need_half_heart:
		hearts_container.add_child(pHalfIcon.instantiate())
	
	# Add empty hearts
	for i in range(empty_hearts):
		hearts_container.add_child(pEmptyIcon.instantiate())