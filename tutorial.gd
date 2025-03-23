extends CanvasLayer

var steps: Array = [
	"Welcome young alchemist!\n To grow into a famous and successful alchemist you must do the following...",
	"... you have to learn and create all kinds of potions and elixirs.",
	"To do this, you have to learn recipes and research ingredients.",
	"To make a potion you have to put ingredients (click on it) into the cauldron. And click on the cauldron to brew.",
	"At least 2 ingredients must be used the maximum amount of ingredients depends on your experience (researched ingredients)\nAn ingredient can only be used once per potion. (No double addition possible)",
	"To increase your knowledge, you must create the required potion. Click on the quest sign to see the potion you currently have to create.",
	"Recipes that you already know, learned through growing experience or experimentation, can be looked up in the alchemy book.",
	"You don't always know the recipe for the potion you need, which means you have to experiment to create the potion and learn new recipes but...",
	"... there is also a great danger if you mix the wrong ingredients together you may create a “CHAOS” potion.",
	"If you create such a CHAOS potion, you lose one of your six vials. And if you no longer have any vials, you are better off as an alchemist.",
	"Only creating / researching new potions gives you experience. And making the potion you need.",
	"This means that making an already known potion several times does not give you any experience (unless the potion is the one you currently want)",
	"Now take a look at which potion is required (quest sign).\n\nNote: You can find the first recipe in the book"
]

var current_step: int = 0

@onready var rich_text_label: RichTextLabel = $TextureRect/RichTextLabel
@onready var phiolen: ColorRect = $ColorRect/Phiolen
@onready var ingredients: ColorRect = $ColorRect/Ingredients
@onready var book: ColorRect = $ColorRect/Book
@onready var quest: ColorRect = $ColorRect/Quest
@onready var button: Button = $TextureRect/Button


func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	update_step()

func update_step() -> void:
	match current_step:
		0,1,2,8,10,11:
			ingredients.hide()
			phiolen.hide()
			book.hide()
			quest.hide()
		3,4:
			ingredients.show()
			phiolen.hide()
			book.hide()
			quest.hide()
		9:
			ingredients.hide()
			phiolen.show()
			book.hide()
			quest.hide()
		6:
			ingredients.hide()
			phiolen.hide()
			book.show()
			quest.hide()
		5:
			ingredients.hide()
			phiolen.hide()
			book.hide()
			quest.show()
		12:
			ingredients.hide()
			phiolen.hide()
			book.show()
			quest.show()
	button.disabled = true
	rich_text_label.visible_ratio = 0
	rich_text_label.text = steps[current_step]
	var tween: Tween = create_tween()
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, 1.5)
	await tween.finished
	button.disabled = false
	
	
func _on_button_pressed() -> void:
	current_step += 1
	if current_step < steps.size():
		update_step()
	else:
		GameManager.tutorial_done = true
		queue_free()  # Entfernt das Tutorial
