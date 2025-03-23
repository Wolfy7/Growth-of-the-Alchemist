extends AnimatedSprite2D


func add_ingredient() -> void:
	play("add")
	
func brew_potion() -> void:
	play("brew")

func _on_animation_finished() -> void:
	play("idle")
	
