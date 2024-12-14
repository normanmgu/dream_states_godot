# base_enemy.gd
extends CharacterBody2D
class_name BaseEnemy

# Base stats
@export var speed: float = 40.0
@export var health: float = 100.0
@export var knockback_force: float = 300.0
@export var knockback_duration: float = 0.25

# Common variables
var player: Node2D = null
var player_chase: bool = false
var player_in_attack_zone: bool = false
var can_take_damage: bool = true
var is_dying = false

# Knockback variables
var is_being_knocked_back: bool = false
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

func enemy():
    # used to verify object is an enemy by other nodes
    pass


func _ready() -> void:
    # Connect all the signals programmatically
    var detection_area = $detection_area
    var enemy_hitbox = $enemy_hitbox
    var damage_cooldown = $take_damage_cooldown
    
    if detection_area:
        detection_area.body_entered.connect(_on_detection_area_body_entered)
        detection_area.body_exited.connect(_on_detection_area_body_exited)
    else:
        push_error("Detection area not found in ", name)
        
    if enemy_hitbox:
        enemy_hitbox.body_entered.connect(_on_enemy_hitbox_body_entered)
        enemy_hitbox.body_exited.connect(_on_enemy_hitbox_body_exited)
    else:
        push_error("Enemy hitbox not found in ", name)
        
    if damage_cooldown:
        damage_cooldown.timeout.connect(_on_take_damage_cooldown_timeout)
    else:
        push_error("Take damage cooldown timer not found in ", name)
    
    setup_animations()

# Virtual method - Must be implemented by child classes
func setup_animations() -> void:
    push_error("setup_animations() not implemented in ", name)

# Virtual method - Must be implemented by child classes
func perform_attack() -> void:
    push_error("perform_attack() not implemented in ", name)

func _physics_process(delta: float) -> void:
    deal_with_damage()
    if is_being_knocked_back:
        handle_knockback(delta)
    else:
        handle_movement(delta)
    move_and_slide()

# Virtual method - Can be overridden by child classes
func handle_movement(_delta: float) -> void:
    if not is_dying:
        if player_chase:
            var direction = (player.position - position).normalized()
            velocity = direction * speed
            play_movement_animation(direction)
        else:
            velocity = Vector2.ZERO
            play_idle_animation()

# Virtual method - Must be implemented by child classes
func play_movement_animation(_direction: Vector2) -> void:
    push_error("play_movement_animation() not implemented in ", name)

# Virtual method - Must be implemented by child classes
func play_idle_animation() -> void:
    push_error("play_idle_animation() not implemented in ", name)

func handle_knockback(delta: float) -> void:
    knockback_timer -= delta
    if knockback_timer <= 0:
        is_being_knocked_back = false
        return
    
    velocity = knockback_direction * knockback_force * (knockback_timer / knockback_duration)

func apply_knockback(attacker_position: Vector2) -> void:
    knockback_direction = (global_position - attacker_position).normalized()
    is_being_knocked_back = true
    knockback_timer = knockback_duration

func take_damage(amount: float, attacker_position: Vector2) -> void:
    if can_take_damage:
        $take_damage_cooldown.start()
        can_take_damage = false
        health -= amount
        print("slime health: ", health)
        apply_knockback(attacker_position)
        
        if health <= 0:
            die()

# Virtual method - Can be overridden by child classes
func die() -> void:
    if is_dying:
        return
    is_dying = true
    play_death_animation()

func play_death_animation() -> void:
    push_error("play_death_animation() is not implemented")

func _on_detection_area_body_entered(body: Node2D) -> void:
    if body.has_method("player"):
        player = body
        player_chase = true

func _on_detection_area_body_exited(_body: Node2D) -> void:
    player = null
    player_chase = false

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
    if body.has_method("player"):
        print("enemy hitbox entered")
        player_in_attack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
    if body.has_method("player"):
        player_in_attack_zone = false

func _on_take_damage_cooldown_timeout() -> void:
    can_take_damage = true

func deal_with_damage():
    if player_in_attack_zone and global.player_current_attack:
        if can_take_damage and player:
            take_damage(20, player.global_position) 