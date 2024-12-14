extends BaseEnemy
class_name Slime

@export var slime_type: int = 0
@onready var sprite_version = $sprite

func _ready() -> void:
    super._ready()
    speed = 40.0
    health = 100.0
    knockback_force = 300.0
    knockback_duration = 0.25
    sprite_version.animation_finished.connect(_on_animated_sprite_animation_finished)

func setup_animations() -> void:
    # Set up any slime-specific animation properties
    pass

func get_slime_type() -> String:
    return "happy_" if slime_type == 0 else "mad_"

func play_movement_animation(direction: Vector2) -> void:
    if not is_dying:
        sprite_version.play(get_slime_type() + "walk_front")
        sprite_version.flip_h = direction.x < 0

func play_idle_animation() -> void:
    if not is_dying:
        sprite_version.play(get_slime_type() + "idle_front")


func perform_attack() -> void:
    # Implement slime-specific attack
    pass

func play_death_animation():
    sprite_version.play(get_slime_type() + "death")


func _on_animated_sprite_animation_finished() -> void:
    print("animation ended")
    if is_dying and sprite_version.animation.ends_with("death"):
        print('sprite finished')
        queue_free()
