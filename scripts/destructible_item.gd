extends AnimatableBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player") and Global.player_current_rollin:
		animation_player.play("destroyed")
