extends TextureButton
class_name IngredientButton

signal ingredient_added(ingredient: Ingredient)

@export var ingredient_data: Ingredient

func _ready() -> void:
	texture_normal = ingredient_data.icon
	scale = Vector2(0.4, 0.4)
	if ingredient_data.unknown:
		tooltip_text = "???"
		self_modulate = Color.BLACK
		disabled = true
	else:
		tooltip_text = ingredient_data.tooltip
		self_modulate = Color.WHITE
		disabled = false

func unlock() -> void:
		tooltip_text = ingredient_data.tooltip
		self_modulate = Color.WHITE
		disabled = false
		ingredient_data.unknown = false
		
func update(level: int) -> void:
	#tooltip_text = ingredient_data.tooltip
	#self_modulate = Color.WHITE
	#disabled = false
	pass

func _on_pressed() -> void:
	ingredient_added.emit(ingredient_data)
	disabled = true
	await get_tree().create_timer(0.4).timeout
	disabled = false

#func _make_custom_tooltip(for_text: String) -> Object:
	#var tooltip: Node = preload("res://ingredient_tooltip.tscn").instantiate()
	#tooltip.get_node("RichTextLabel").text = for_text
	#return tooltip
