extends Label

func _physics_process(delta: float) -> void:
	self.text = str(Global.player_health)
