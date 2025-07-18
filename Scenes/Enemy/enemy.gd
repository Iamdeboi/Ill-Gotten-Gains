class_name Enemy
extends Node2D

const ARROW_OFFSET := 5
const RED_SPRITE_MATERIAL := preload("res://Assets/art/red_sprite_material.tres")
const WHITE_SPRITE_MATERIAL := preload("res://Assets/art/white_sprite_material.tres")

# Statblock + Assets + StatsUI + Intents
@export var stats: EnemyStats : set = set_enemy_stats

@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var stats_ui: StatsUI = $StatsUI
@onready var target_arrow: Sprite2D = %TargetArrow
@onready var intent_ui: IntentUI = $IntentUI
@onready var status_handler: StatusHandler = $StatusHandler
@onready var modifier_handler: ModifierHandler = $ModifierHandler

var enemy_action_picker: EnemyActionPicker
var current_action: EnemyAction: set = set_current_action


func _ready() -> void:
	status_handler.status_owner = self

func set_current_action(value: EnemyAction) -> void:
	current_action = value
	if current_action:
		if current_action.has_method("calculate_action") and current_action.effect_count > 1:
			current_action.intent.set_number(str(current_action.calculate_action()) + " x " + str(current_action.effect_count))
		elif current_action.has_method("calculate_action"):
			current_action.intent.set_number(str(current_action.calculate_action()))
		intent_ui.update_intent(current_action.intent)


func set_enemy_stats(value: EnemyStats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		stats.stats_changed.connect(update_action)
	
	update_enemy()


func setup_ai() -> void:
	if enemy_action_picker:
		enemy_action_picker.queue_free()
	
	var new_action_picker: EnemyActionPicker = stats.ai.instantiate()
	add_child(new_action_picker)
	enemy_action_picker = new_action_picker # Assign the instance of EnemyActionPicker to a new variable
	enemy_action_picker.enemy = self # Sets enemy reference propery to self


func update_action() -> void:
	if not enemy_action_picker:
		return
	
	if not current_action:
		current_action = enemy_action_picker.get_action()
		return
	# Check to see if a conditional ability can be queued after reaching a certain threshold after an effect/damage event occurs
	var new_conditional_action := enemy_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action


func update_enemy() -> void:
	if not stats is BaseStats:
		return
	if not is_inside_tree():
		await ready
	
	enemy_sprite.texture = stats.sprite
	setup_ai()
	update_stats()


func do_turn() -> void:
	if not current_action:
		return
	
	current_action.perform_action()


func update_stats() -> void:
	stats_ui.update_stats(stats)


func calculate_damage(amount: int, dmg_mod: float, primary_scaling_mod: float, secondary_scaling_mod: float) -> int:
	return stats.calculate_damage(amount, dmg_mod, primary_scaling_mod, secondary_scaling_mod)


func take_damage(amount: int, which_modifier: Modifier.Type) -> void:
	if stats.health <= 0:
		return
	
	if stats.armor <= amount: # Damage will reduce health
		enemy_sprite.material = RED_SPRITE_MATERIAL
	else: # Damage will be fully absorbed by armor before reducing health
		enemy_sprite.material = WHITE_SPRITE_MATERIAL
	
	var modified_damage := modifier_handler.get_modified_value(amount, which_modifier)
	var tween := create_tween()
	SfxPlayer.play(stats.hit_sound)
	tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(modified_damage))
	tween.tween_interval(0.15)
	
	tween.finished.connect(
		func():
			enemy_sprite.material = null
			
			if stats.health <= 0:
				SfxPlayer.play(stats.death_sound)
				EventBus.enemy_died.emit(self)
				queue_free()
	)


func _on_area_entered(_area: Area2D) -> void:
	target_arrow.show()


func _on_area_exited(_area: Area2D) -> void:
	target_arrow.hide()
