extends Control

@export var current_xp := 0
@export var xp_for_next_level := 100

func _ready():
	update_bar()

func update_bar():
	var ratio = float(current_xp) / xp_for_next_level
	ratio = clamp(ratio, 0.0, 1.0)
	$FillBar.custom_minimum_size.x = $BackgroundBar.size.x * ratio
