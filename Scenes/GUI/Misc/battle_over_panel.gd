class_name BattleOverPanel
extends Panel

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continue_button: Button = %ContinueButton
@onready var restart_button: Button = %RestartButton


func _ready() -> void:
	continue_button.pressed.connect(func(): EventBus.battle_won.emit())
	restart_button.pressed.connect(get_tree().reload_current_scene)
	EventBus.battle_over_screen_requested.connect(show_screen)


func show_screen(text: String, type: Type) -> void:
	label.text = text
	continue_button.visible = type == Type.WIN # If combat won, continue button shown
	restart_button.visible = type == Type.LOSE # If combat lose, restart button shown
	show()
	get_tree().paused = true  # Pauses the entire game when the screen appears, preventing further actions in combat
