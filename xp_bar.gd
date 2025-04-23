extends Control

@onready var texture_rect: TextureRect = $VBoxContainer/HBoxContainer/TextureRect
@onready var texture_progress_bar: TextureProgressBar = $VBoxContainer/HBoxContainer/TextureProgressBar
@onready var texture_rect_2: TextureRect = $VBoxContainer/HBoxContainer/TextureRect2
@onready var label: Label = $VBoxContainer/Label

const barBack_horizontalLeft: Resource = preload("res://assets/xp_bar/barBack_horizontalLeft.png")
const barBack_horizontalRight: Resource = preload("res://assets/xp_bar/barBack_horizontalRight.png")
const barGreen_horizontalLeft: Resource = preload("res://assets/xp_bar/barGreen_horizontalLeft.png")
const barGreen_horizontalRight: Resource = preload("res://assets/xp_bar/barGreen_horizontalRight.png")

func _ready() -> void:
	texture_progress_bar.min_value = float(GameManager.level_xp[GameManager.level][0])
	texture_progress_bar.max_value = float(GameManager.level_xp[GameManager.level][1])
	texture_progress_bar.value = float(GameManager.xp)
	label.text = GameManager.level_xp[GameManager.level][2]


func update_xp_bar() -> void:
	prints("update_xp_bar", texture_progress_bar.min_value, texture_progress_bar.max_value)
	animate_xp_bar(float(GameManager.xp))

func animate_xp_bar(to_value: float) -> void:
	print("animate_xp_bar: ",to_value)
	var tween: Tween = create_tween()
	tween.tween_property(
		texture_progress_bar,
		"value",
		clamp(to_value, 0, texture_progress_bar.max_value),
		0.5  # Dauer in Sekunden
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	texture_progress_bar.min_value = float(GameManager.level_xp[GameManager.level][0])
	texture_progress_bar.max_value = float(GameManager.level_xp[GameManager.level][1])
	label.text = GameManager.level_xp[GameManager.level][2]

func _on_texture_progress_bar_value_changed(value: float) -> void:
	if value > texture_progress_bar.min_value:
		texture_rect.texture = barGreen_horizontalLeft
	else :
		texture_rect.texture = barBack_horizontalLeft
		
	if value >= texture_progress_bar.max_value:
		texture_rect_2.texture = barGreen_horizontalRight
	else :
		texture_rect_2.texture = barBack_horizontalRight
		
	#prints("_on_texture_progress_bar_value_changed", texture_progress_bar.min_value, texture_progress_bar.max_value, value)


func _on_texture_progress_bar_changed() -> void:
	print(texture_progress_bar.min_value, texture_progress_bar.max_value, GameManager.xp)
	_on_texture_progress_bar_value_changed(float(GameManager.xp))
