extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ROLL_SPEED = 400

@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio
@onready var rollin_timer: Timer = $RollinTimer

var direction_state = 1
var rollin_in_progress = false

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
	if rollin_in_progress:
		print(ROLL_SPEED * direction_state)
		velocity.x = ROLL_SPEED * direction_state
	
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
		print("user press rollin")
		Global.player_current_rollin = true
		rollin_in_progress = true
		rollin_timer.start()

func _on_rollin_timer_timeout() -> void:
	rollin_timer.stop()
	Global.player_current_rollin = false
	rollin_in_progress = false
	
func damage_taken(damage: int):
	pass
