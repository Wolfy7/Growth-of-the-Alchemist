extends Control
@export var recipe: Recipe

@onready var rich_text_label_2: RichTextLabel = $VBoxContainer/VFlowContainer/RichTextLabel2
@onready var grid_container: GridContainer = $VBoxContainer/VFlowContainer/HBoxContainer/GridContainer
@onready var control: Control = $VBoxContainer/VFlowContainer/ColorRect2/Control
@onready var label: Label = $VBoxContainer/Label
@onready var color_rect: ColorRect = $VBoxContainer/VFlowContainer/RichTextLabel2/Label/ColorRect

func _ready() -> void:
	#print(recipe.description)
	label.text = recipe.name
	var description_text: String = recipe.description
	description_text += " "
	rich_text_label_2.text = description_text
	
	color_rect.color = recipe.color
	
	if recipe.potion:
		var potion: Node = recipe.get_node()
		#potion.position.y = 10
		potion.scale = Vector2(0.85, 0.85)
		control.add_child(potion)
	
	var index: int = 1
	for ingredient: Ingredient in recipe.ingredients:
		var label: Label = Label.new()
		label.text = str(index)
		label.set("theme_override_fonts/font", preload("res://assets/fonts/CaslonAntique.ttf"))
		label.set("theme_override_font_sizes/font_size", 32)
		
		var text_rect: TextureRect = TextureRect.new()
		text_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		text_rect.custom_minimum_size = Vector2(80, 80)
		text_rect.texture = ingredient.icon
		text_rect.tooltip_text = ingredient.name
		if ingredient.unknown:
			text_rect.self_modulate = Color.BLACK
			text_rect.tooltip_text = "???"
		
		text_rect.add_child(label)
		grid_container.add_child(text_rect)
		
		index += 1
