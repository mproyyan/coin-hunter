extends Area2D

@onready var frozen_timer: Timer = $FrozenTimer
@onready var hurt_animation_timer: Timer = $HurtAnimationTimer

var player: Node2D = null

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		frozen_timer.start()
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		frozen_timer.stop()
		Global.can_play_frostbite_animation = false

func _on_frozen_timer_timeout() -> void:
	if player:
		hurt_animation_timer.start()
		Global.can_play_frostbite_animation = true
		player.frostbite()

func _on_hurt_animation_timer_timeout() -> void:
	Global.can_play_frostbite_animation = false
