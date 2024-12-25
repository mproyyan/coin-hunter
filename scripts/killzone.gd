extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player") and Global.player_alive:
		body.get_node("CollisionShape2D").queue_free()
		body.damage_taken(100)
