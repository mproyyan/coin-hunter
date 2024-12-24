extends AnimatableBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox

func _physics_process(delta: float) -> void:
	if check_if_player_body_already_in_hitbox() and Global.player_current_rollin:
		animation_player.play("destroyed")

func check_if_player_body_already_in_hitbox() -> bool:
	var overlapping_bodies = hitbox.get_overlapping_bodies()
	for overlap_body in overlapping_bodies:
		if overlap_body.has_method("player"):
			return true
	
	return false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player") and Global.player_current_rollin:
		animation_player.play("destroyed")
