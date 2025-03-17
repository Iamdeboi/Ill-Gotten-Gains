class_name BattleReward
extends Control


func _on_button_pressed() -> void:
	EventBus.battle_reward_exited.emit()
