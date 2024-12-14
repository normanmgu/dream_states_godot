extends Camera2D

@export var player_path: NodePath
@onready var player = get_node(player_path)

func _ready() -> void:
	self.zoom += Vector2(2, 2)

func _process(_delta: float) -> void:
	if is_instance_valid(player):
		global_position = player.global_position
