extends Node

@export var level1: Array[Ingredient]
@export var level2: Array[Ingredient]
@export var level3: Array[Ingredient]
@export var level4: Array[Ingredient]
@export var level5: Array[Ingredient]
@export var level6: Array[Ingredient]
@export var level7: Array[Ingredient]
@export var level8: Array[Ingredient]
@export var level9: Array[Ingredient]
@export var level10: Array[Ingredient]
@export var level11: Array[Ingredient]
@export var level12: Array[Ingredient]
@export var level13: Array[Ingredient]
@export var level14: Array[Ingredient]
@export var level15: Array[Ingredient]
@export var recipes: Array[Recipe]
@export var particles: Array[Texture]
@export var potion_scene: PackedScene

@onready var know_ingredients: Dictionary

var prefixes: Array = ["Elixir", "Potion", "Draught", "Philter", "Concoction", "Essence", "Tonic", "Infusion", "Distillate"]
var elements: Array = ["Shadow", "Flame", "Frost", "Arcane", "Mystic", "Venom", "Aether", "Eldritch", "Storm", "Sun", "Lunar", "Celestial", "Void", "Blood", "Spectral", "Infernal"]
var effects: Array = ["Strength", "Wisdom", "Regeneration", "Vitality", "Invisibility", "Growth", "Curses", "Fortune", "Clarity", "Decay", "Resilience", "Agility", "Mind", "Corruption", "Purity", "Fury"]

var generated_names: Dictionary = {}  # Set zur Speicherung bereits vergebener Namen

func generate_unique_potion_name() -> String:
	var name: String = ""
	
	# Wiederhole, bis ein Name gefunden wurde, der noch nicht existiert
	while true:
		name = prefixes.pick_random() + " of " + elements.pick_random() + " " + effects.pick_random()
		
		# Falls der Name bereits existiert, wiederhole die Schleife
		if not generated_names.has(name):
			generated_names[name] = true  # Speichere den Namen im Set
			break
	return name
	
var effect_descriptions: Dictionary = {
	"Strength": "empowers the body with immense force",
	"Wisdom": "sharpens the mind and reveals hidden truths",
	"Regeneration": "rapidly heals wounds and restores energy",
	"Vitality": "fills the user with boundless stamina",
	"Invisibility": "renders the drinker unseen to the naked eye",
	"Growth": "accelerates natural development and expansion",
	"Curses": "brings misfortune upon its victims",
	"Fortune": "enhances luck and prosperity",
	"Clarity": "clears the mind of doubt and deception",
	"Decay": "slowly withers away whatever it touches",
	"Resilience": "makes the drinker nearly indestructible",
	"Agility": "grants superhuman speed and reflexes",
	"Mind": "enhances psychic abilities and mental focus",
	"Corruption": "twists the soul and bends reality",
	"Purity": "cleanses all evil and impurities",
	"Fury": "unleashes uncontrollable rage and power"
}

func generate_potion_description(potion_name: String) -> String:
	var description: String = "This [color=900101]" + potion_name+ "[/color] is known for its ability to "
	
	# Extrahiere den Effekt aus dem Tranknamen
	var effect_found: bool = false
	for effect: String in effect_descriptions.keys():
		if effect in potion_name:
			description += effect_descriptions[effect] + ". "
			effect_found = true
			break
	
	# Falls kein direkter Effekt gefunden wurde, generiere eine generische Beschreibung
	if not effect_found:
		description += "produce unknown magical effects. "
	
	# Zutaten hinzufügen
	#if ingredients.size() > 0:
		#description += "It is crafted from " 
		#var ingredient_list = []
		#for ingredient in ingredients:
			#if ingredient_descriptions.has(ingredient):
				#ingredient_list.append(ingredient_descriptions[ingredient])
			#else:
				#ingredient_list.append("a mysterious substance")
		#description += ", ".join(ingredient_list) + "."
	return description

func generate_recipes(amount:int, ingredient_min:int, ingredients: Array[Ingredient]) -> Array[Recipe]:
	var generated_recipes: Array[Recipe]
	for i: int in amount:
		var recipe: Recipe = Recipe.new() 
		var guard: int = 0
		var break_generation: bool = false
		var recipe_ingredients: Array[Ingredient] = get_ingredients(ingredient_min, ingredients)
		while know_ingredients.has(recipe_ingredients):
			if guard > 10:
				break_generation = true
				break
			recipe_ingredients = get_ingredients(ingredient_min, ingredients)
			guard += 1
		
		if break_generation:
			break
		
		know_ingredients[recipe_ingredients] = recipe_ingredients
		recipe.ingredients = recipe_ingredients
		
		recipe.name = generate_unique_potion_name()
		recipe.description = generate_potion_description(recipe.name)
		recipe.color = get_color(recipe.ingredients)
		recipe.particle = particles.pick_random()
		
		recipe.potion = potion_scene
		
		generated_recipes.append(recipe)
	return generated_recipes

func get_ingredients(amount: int, know_ingredients: Array[Ingredient]) -> Array[Ingredient]:
	var ingredients: Array[Ingredient]
	
	while  ingredients.size() != amount:
		var ingredient:Ingredient
		ingredient = know_ingredients.pick_random()

		if not ingredient in ingredients:
			ingredients.append(ingredient)
	return ingredients
	
func get_color(ingredients: Array[Ingredient]) -> Color:
	var color: Color = Color.WHITE
	for ingredient: Ingredient in ingredients:
		color = color.lerp(ingredient.color, ingredient.coloring)
	return color
 
