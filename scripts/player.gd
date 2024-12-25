extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ROLL_SPEED = 400

@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio
@onready var rollin_timer: Timer = $RollinTimer
@onready var dead_timer: Timer = $DeadTimer
@onready var hurt_audio: AudioStreamPlayer2D = $HurtAudio
@onready var knockback_timer: Timer = $KnockbackTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction_state = 1
var rollin_in_progress = false
var knockback_in_progress = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_audio.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	change_direction_state(direction)
	
	rollin()
	if rollin_in_progress and Global.player_alive:
		velocity.x = ROLL_SPEED * direction_state
	
	if knockback_in_progress and Global.player_alive:
		var knockback_direction = 1
		if direction_state == 1:
			knockback_direction = -1
		elif direction_state == -1:
			knockback_direction == 1
			
		velocity.x = knockback_direction * 100
	
	if direction_state == 1 and Global.player_alive:
		animated_sprite.flip_h = false
	elif direction_state == -1 and Global.player_alive:
		animated_sprite.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func change_direction_state(direction: int):
	if direction == 1:
		direction_state = 1
	elif direction == -1:
		direction_state = -1
		
func rollin():
	if Input.is_action_just_pressed("rollin") and Global.player_alive:
		Global.player_current_rollin = true
		rollin_in_progress = true
		rollin_timer.start()

func _on_rollin_timer_timeout() -> void:
	rollin_timer.stop()
	Global.player_current_rollin = false
	rollin_in_progress = false
	
func damage_taken(damage: int):
	Global.player_health -= damage
	if Global.player_health < 0 and Global.player_alive:
		Global.player_health = 0
		Global.player_alive = false
		Engine.time_scale = 0.5
		dead_timer.start()

func frostbite():
	hurt_audio.play()
	damage_taken(2)
	
func knockback(damage: int):
	hurt_audio.play()
	knockback_in_progress = true
	knockback_timer.start()
	damage_taken(damage)

func _on_dead_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")

func _on_knockback_timer_timeout() -> void:
	knockback_in_progress = false
