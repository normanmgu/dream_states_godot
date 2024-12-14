extends CharacterBody2D

enum Direction { RIGHT, LEFT, DOWN, UP}


@export var speed = 150.0
# @export var health = 100.0
@export var max_health = 3
@export var current_health = 3

var player_alive = true

var current_direction = null
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var attack_ip = false

var last_pressed_direction = Direction.DOWN

func player():
	pass


func _ready() -> void:
	current_direction = Direction.DOWN
	$AnimatedSprite2D.play("idle_front")

	global.health_changed.emit(current_health, max_health)


func _physics_process(delta: float) -> void:
	
	player_movement(delta)
	enemy_attack()
	attack()

	if current_health <= 0:
		player_alive = false # add death scene
		print("player has been killed")
		self.queue_free()

func play_anim(movement):
	var anim = $AnimatedSprite2D

	match current_direction:
		Direction.RIGHT:
			anim.flip_h = false
			if movement == 1:
				anim.play("walk_side")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_side")
		Direction.LEFT:
			anim.flip_h = true
			if movement == 1:
				if attack_ip == false:
					anim.play("walk_side")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_side")
		Direction.UP:
			anim.flip_h = false
			if movement == 1:
				anim.play("walk_back")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_back")
		Direction.DOWN:
			anim.flip_h = false
			if movement == 1:
				anim.play("walk_front")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_front")

func player_movement(_delta: float):
	if attack_ip:
		return
	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
		current_direction = Direction.RIGHT
		play_anim(1)
		var normal = Vector2(1, -1)
		normal = normal.normalized()
		velocity.x = normal.x * speed
		velocity.y = normal.y * speed
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
		current_direction = Direction.RIGHT
		play_anim(1)
		var normal = Vector2(1, 1)
		normal = normal.normalized()
		velocity.x = normal.x * speed
		velocity.y = normal.y * speed
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up"):
		current_direction = Direction.LEFT
		play_anim(1)
		var normal = Vector2(-1, -1)
		normal = normal.normalized()
		velocity.x = normal.x * speed
		velocity.y = normal.y * speed
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
		current_direction = Direction.LEFT
		play_anim(1)
		var normal = Vector2(-1, 1)
		normal = normal.normalized()
		velocity.x = normal.x * speed
		velocity.y = normal.y * speed
	elif Input.is_action_pressed("ui_right"):
		current_direction = Direction.RIGHT
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = Direction.LEFT
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0	
	elif Input.is_action_pressed("ui_down"):
		current_direction = Direction.DOWN
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_direction = Direction.UP
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		current_health -= .5
		enemy_attack_cooldown = false
		global.health_changed.emit(current_health, max_health)
		$attack_cooldown.start()
		print(current_health)	

func perform_attack(attack_direction: Direction):
	global.player_current_attack = true
	attack_ip = true
	
	match attack_direction:
			Direction.RIGHT:
					$AnimatedSprite2D.flip_h = false
					$AnimatedSprite2D.play("attack_side")
			Direction.LEFT:
					$AnimatedSprite2D.flip_h = true
					$AnimatedSprite2D.play("attack_side")
			Direction.UP:
					$AnimatedSprite2D.flip_h = false
					$AnimatedSprite2D.play("attack_back")
			Direction.DOWN:
					$AnimatedSprite2D.flip_h = false
					$AnimatedSprite2D.play("attack_front")
	
	$deal_attack_timer.start()


func attack():

	if Input.is_action_just_pressed("attack_right"):
		perform_attack(Direction.RIGHT)
	elif Input.is_action_just_pressed("attack_left"):
		perform_attack(Direction.LEFT)
	elif Input.is_action_just_pressed("attack_up"):
		perform_attack(Direction.UP)
	elif Input.is_action_just_pressed("attack_down"):
		perform_attack(Direction.DOWN)


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
