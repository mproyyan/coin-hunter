extends CanvasLayer

func _on_play_again_button_pressed() -> void:
	Global.player_alive = true
	Global.player_health = 100
	Global.player_current_rollin = false
	Global.can_play_frostbite_animation = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")
