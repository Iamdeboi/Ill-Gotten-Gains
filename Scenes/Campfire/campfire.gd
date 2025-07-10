class_name Campfire
extends Control

@export var player_stats: PlayerStats

@onready var rest_button: Button = $UILayer/UI/RestButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer # Plays "fade_out" animation
@onready var healing_sound: AudioStream = preload("res://Assets/Audio/50_RPG_Heals_Buffs_SFX/04_Heal_04.wav")

func _on_rest_button_pressed() -> void:
	rest_button.disabled = true
	player_stats.heal(ceili(player_stats.max_health * 0.4))
	SfxPlayer.play(healing_sound)
	animation_player.play("fade_out")


# Method called from AnimationPlayer: "fade_out"
func _on_fade_out_finished() -> void:
	EventBus.campfire_exited.emit()
