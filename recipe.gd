extends Resource
class_name Recipe

@export var name: String
@export_multiline var description: String
#@export var effect: String
@export var good: bool # True = good potion, false = bad potion
@export var ingredients: Array[Ingredient]
@export var potion: PackedScene
@export var color: Color
@export var particle: Texture


func get_node() -> Node:
	var scene: Node = potion.instantiate()
	scene.amount = randi_range(8, 24)
	scene.lifetime = randf_range(0.5, 2.5)
	scene.liquid_color = color
	scene.texture = particle
	scene.color_ramp = create_gradient(color)
	return scene
	
func create_gradient(color: Color) -> GradientTexture1D:
	var gradient: Gradient = Gradient.new()
	gradient.add_point(1.0, Color.WHITE)
	#gradient.add_point(0.0, Color.GREEN)
	gradient.add_point(0.5, color)

	var gradient_texture: GradientTexture1D = GradientTexture1D.new()
	gradient_texture.gradient = gradient
	return gradient_texture
