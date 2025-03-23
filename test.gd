extends Node2D

@onready var node: Node = $Node

func _ready() -> void:
	var recipes = node.generate_recipes()
	
	for recipe in recipes:
		add_child(recipe.get_node())
