extends Node2D
class_name Caldron

@onready var liquid: Sprite2D = $Liquid
@onready var liquid_particels: GPUParticles2D = $LiquidParticels
@onready var ingredient_sound: AudioStreamPlayer2D = $IngredientSound

func add_ingredient(ingredient: Color, coloring: float) -> void:
	ingredient_sound.pitch_scale = randf_range(0.5, 1.5)
	ingredient_sound.play()
	liquid.modulate = liquid.modulate.lerp(ingredient, coloring)
	liquid_particels.modulate = liquid_particels.modulate.lerp(ingredient, coloring) 

func reset() -> void:
	liquid.modulate = Color.WHITE
	liquid_particels.modulate = Color.WHITE
	
func get_color() -> Color:
	return liquid.modulate
