# Create a new script for your HUD node
extends CanvasLayer

@onready var hearts_container = $HBoxContainer

func _process(delta):
    # Ensure layer is above everything
		if hearts_container:
			layer = 100
			
			# Make sure container expands correctly
			hearts_container.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			hearts_container.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
			
			# Set the container's properties
			hearts_container.position = Vector2(20, 20)  # Distance from top-left corner
			hearts_container.custom_minimum_size = Vector2(100, 30)  # Adjust based on your needs
			
			# Set anchors to keep it in top-left
			hearts_container.anchor_left = 0
			hearts_container.anchor_top = 0
			
			# Add some spacing between hearts if needed
			hearts_container.add_theme_constant_override("separation", 4)
