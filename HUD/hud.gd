extends Control

@onready var hearts_container = $HeartContainer
@onready var game_over_container = $GameOverContainer
@onready var win_container = $WinContainer
var pHeartIcon := preload("res://HUD/HeartIcon.tscn")
var pEmptyIcon := preload("res://HUD/EmptyHeartIcon.tscn")
var pHalfIcon := preload("res://HUD/HalfHeartIcon.tscn")

func _ready():
	# connect to signal
	global.health_changed.connect(_on_player_health_changed)
	global.player_died.connect(_on_player_death)
	global.player_won.connect(_on_player_won)

	if !hearts_container:
		push_error("HeartContainer node not found!")
		return
	# Set it to take up full viewport
	anchors_preset = Control.PRESET_FULL_RECT

	# Set position relative to top-left
	position = Vector2.ZERO
	# Configure the hearts container
	hearts_container.position = Vector2.ZERO
	hearts_container.custom_minimum_size = Vector2(100, 100)

	game_over_container.hide()
	win_container.hide()

func _on_player_death():
	show_game_over()

func _on_player_won():
	show_win()

func show_game_over():
	game_over_container.show()

func show_win():
	win_container.show()

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

func _on_game_over_retry_button_pressed() -> void:
	print("button pressed")
	global.current_scene = "world"
	var error = get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
	if error != OK:
		print("error changing scenes: ", error)

func _on_game_win_retry_button_pressed() -> void:
	global.current_scene = "world"
	var error = get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
	if error != OK:
		print("error changing scenes: ", error)
