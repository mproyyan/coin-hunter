extends AnimatableBody2D

var player_on_platform = false

@onready var platform_area: Area2D = $PlatformArea

func _physics_process(delta: float) -> void:
	if player_on_platform and Input.is_action_just_pressed("squat"):
		platform_area.get_node("CollisionShape2D").rotation_degrees = 180

func _on_platform_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_on_platform = true
		
func _on_platform_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_on_platform = false
		platform_area.get_node("CollisionShape2D").rotation_degrees = 360
