extends Control

@export var recipes: Array[Recipe]
@export var recipe_scene: PackedScene

@onready var tab_container_2: TabContainer = $TabContainer2

var index: int = 1

func _ready() -> void:
	set_recipes(recipes)

func _on_texture_button_pressed() -> void:
	hide()

func set_recipes(recipes: Array[Recipe]) -> void:
	for recipe: Recipe in recipes:
		var node: Control = Control.new()
		var scene: Node = recipe_scene.instantiate()
		scene.recipe = recipe
		node.add_child(scene)
		tab_container_2.add_child(node)
		node.name = str(index)
		index += 1

func add_recipe(recipe: Recipe) -> void:
	if recipe in recipes:
		print("Rezept steht bereits im Buch")
		return
	var node: Control = Control.new()
	var scene: Node = recipe_scene.instantiate()
	scene.recipe = recipe
	node.add_child(scene)
	tab_container_2.add_child(node)
	node.name = str(index)
	index += 1
