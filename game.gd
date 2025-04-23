extends Node

@export var ingredient_button_scene: PackedScene
@export var inventory: Array[Ingredient]
@export var recipes: Array[Recipe]
#@export var quests: Array[Quest]

@onready var node: Node = $Node
@onready var caldron: Caldron = $TileMap/caldron
@onready var grid_container: GridContainer = $CanvasLayer/ScrollContainer/MarginContainer/GridContainer
@onready var book: Control = $CanvasLayer/Book
@onready var alchemist: AnimatedSprite2D = $alchemist
@onready var vials: GridContainer = $CanvasLayer/Vials
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var quest_popup: TextureRect = $CanvasLayer/QuestPopup
@onready var popup_background: ColorRect = $CanvasLayer/PopupBackground
@onready var info_pop_up: TextureRect = $CanvasLayer/InfoPopUp
@onready var info_text: RichTextLabel = $CanvasLayer/InfoPopUp/InfoText
@onready var caldron_label: Label = $CanvasLayer/CaldronLabel
@onready var potion_spot: Control = $CanvasLayer/PotionSpot
@onready var quest_text: RichTextLabel = $CanvasLayer/QuestPopup/QuestText
@onready var quest_color: ColorRect = $CanvasLayer/QuestPopup/QuestText2/QuestColor
@onready var quest_ingredients: RichTextLabel = $CanvasLayer/QuestPopup/QuestText3/QuestIngredients
@onready var game_over: CanvasLayer = $GameOver
@onready var game_over_recipes: RichTextLabel = $GameOver/TextureRect/GameOverRecipes
@onready var tutorial: CanvasLayer = $Tutorial

@onready var xp_bar: Control = $CanvasLayer/XpBar


const CHAOS_POTION: Resource = preload("res://potions/chaos_potion.tscn")

var ingredients: Array = []
var known_recipes: Array[Recipe] = []
var known_ingredients: Array[Ingredient] = []
var current_quest: Recipe

func update_progress_bar() -> void:
	prints("update_progress_bar", GameManager.level_xp[GameManager.level][0], GameManager.level_xp[GameManager.level][1], GameManager.xp)
	xp_bar.update_xp_bar()

func _ready() -> void:
	print(GameManager.level)
	ingredients.clear()
	known_recipes.clear()
	known_ingredients.clear()
	GameManager.level = 1
	GameManager.xp = 0
	if GameManager.tutorial_done:
		tutorial.queue_free()
	
	for item: Ingredient in inventory:
		var scene: IngredientButton = ingredient_button_scene.instantiate()
		scene.ingredient_data = item
		scene.ingredient_added.connect(_on_ingredient_button_ingredient_added)
		grid_container.add_child(scene)
		if item.level_unlock <= GameManager.level:
			known_ingredients.append(item)

	
	recipes = node.generate_recipes(1, 2, known_ingredients)
	known_recipes.append(recipes.get(0))
	
	set_quest(known_recipes.get(0))	
		
	book.set_recipes(known_recipes)
	unlock_ingredients()
	update_ingredients()
	udapte_caldron_label()
	print("Size ",known_ingredients.size())

func udapte_caldron_label() -> void:
	var text: String = str(ingredients.size()) + " / " + str(get_known_ingredients())
	caldron_label.text = text

func get_known_ingredients() -> int:
	var known: int = 0
	for item: Ingredient in inventory:
		if item.unknown:
			break
		known += 1
	return known

func gain_xp(xp: int) -> bool:
	if GameManager.level == GameManager.MAX_LEVEL:
		print("Max level bereits erreicht")
		return false
	 
	print("gain_xp:",xp)
	GameManager.xp += xp
	print("GameManager.xp:",GameManager.xp, "Next level xp: ", GameManager.level_xp[GameManager.level][1])
	if GameManager.xp >= GameManager.level_xp[GameManager.level][1]:
		print("LEVEL UP")
		GameManager.level += 1
		level_up()
		return true
	return false
		
func show_info_popup(text: String) -> void:
	info_text.text = text
	popup_background.show()
	info_pop_up.show()

func level_up() -> void:
	var new_ingredient = unlock_ingredients()
	print("level_up: ", GameManager.level)
	
	for ingredient_amount: int in range(2, known_ingredients.size() + 1):
		var amount: int = (GameManager.permutation_data[known_ingredients.size()][ingredient_amount - 2]) / 2
		amount = mini(amount, 100) # TODO
		for recipe: Recipe in node.generate_recipes(amount, ingredient_amount, known_ingredients):
			if not recipe in recipes:
				recipes.append(recipe)
	
	var text = "GROWN UP "
	text += "\nNew ingredient: " + new_ingredient.name
	while true:
		var new_know_recipe: Recipe = recipes.pick_random()
		if new_know_recipe in known_recipes:
			continue
		known_recipes.append(new_know_recipe)
		book.add_recipe(new_know_recipe)
		text += "\nNew recipe: " + new_know_recipe.name
		break
	show_info_popup(text)

func unlock_ingredients() -> Ingredient:
	known_ingredients.clear()
	var last_unlocked: Ingredient
	for ingredient: IngredientButton in grid_container.get_children():
		if ingredient.ingredient_data.level_unlock <= GameManager.level:
			ingredient.unlock()
			udapte_caldron_label()
		if not ingredient.ingredient_data.unknown:
			known_ingredients.append(ingredient.ingredient_data)
			last_unlocked = ingredient.ingredient_data
	return last_unlocked

func update_ingredients() -> void:
	for ingredient: IngredientButton in grid_container.get_children():
		ingredient.update(GameManager.level)

func set_quest(quest: Recipe) -> void:
	current_quest = quest
	print("Quest:", current_quest.name)
	quest_text.text = current_quest.name
	quest_color.color = current_quest.color
	quest_ingredients.text = str(current_quest.ingredients.size())

func brew_potion() -> void:
	print("brew_potion")
	var potion: Recipe = null
	for recipe: Recipe in recipes:
		if ingredients == recipe.ingredients:
			potion = recipe
	check_potion(potion)


func check_potion(potion: Recipe) -> void:
	var potion_scene: Node
	var xp_earned = 0
	var info_text: String = ""
	if potion:
		info_text = potion.name + " crafted.\n"
		potion_scene = potion.get_node()
		if not potion in known_recipes:
			book.add_recipe(potion)
			known_recipes.append(potion)
			# TODO: gain XP
			xp_earned += 50
			info_text += "New recipe added.\n Your experience has grown a bit\n"
		
		if potion == current_quest:
			xp_earned += 100
			set_quest(recipes.pick_random())
			info_text += "Quest done. Your experience has grown. \n Next quest: " + current_quest.name
	else:
		potion_scene = CHAOS_POTION.instantiate()
		# Remove potion
		var vials_array: Array[Node] = vials.get_children()
		var vial: Node = vials_array.back()
		vials.remove_child(vial)
		info_text = "Oh no, you create an [color=000000]CHAOS[/color] Potion!!!\n You lose one phiole."

	potion_scene.scale = Vector2(0.5, 0.5)
	potion_spot.add_child(potion_scene)
	
	show_info_popup(info_text)
	await info_pop_up.hidden
	await get_tree().create_timer(0.2).timeout
	
	if xp_earned > 0:
		if gain_xp(xp_earned):
			await info_pop_up.hidden
		update_progress_bar()

	# TODO: check for GameOver 
	if vials.get_children().is_empty():
		game_over_recipes.text = "Recipe book has grown to [color=900101]"+ str(known_recipes.size()) +"[/color] potion recipes"
		game_over.show()
	ingredients.clear()
	caldron.reset()
	udapte_caldron_label()
	# TODO: potion_spot clear

func _on_brew_button_pressed() -> void:
	if ingredients.size() <= 1:
		print("Zuwenige Zutaten!!!")
		# TODO: show hint
		return
		
	alchemist.brew_potion()
	audio_stream_player_2d.play()
	await alchemist.animation_finished
	brew_potion()


func _on_ingredient_button_ingredient_added(ingredient: Ingredient) -> void:
	if ingredients.size() >= get_known_ingredients():
		print("Zuviele Zutaten!")
		# TODO: show hint
		return
	if ingredient in ingredients:
		print("Bereits enthalten!")
		# TODO: show hint
		return
	print("Added: ",ingredient.name)
	caldron.add_ingredient(ingredient.color, ingredient.coloring)
	ingredients.append(ingredient)
	alchemist.add_ingredient()
	udapte_caldron_label()

func _on_texture_button_pressed() -> void:
	book.show()
	
func _on_quest_info_button_pressed() -> void:
	if quest_popup.visible:
		animation_player.play("hide_quest")
		popup_background.hide()
	else:
		animation_player.play_backwards("hide_quest")
		popup_background.show()
	
func _on_quest_popup_button_pressed() -> void:
	animation_player.play("hide_quest")
	popup_background.hide()


func _on_info_popup_button_pressed() -> void:
	popup_background.hide()
	info_pop_up.hide()


func _on_try_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
