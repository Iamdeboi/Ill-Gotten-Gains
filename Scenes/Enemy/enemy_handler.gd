class_name EnemyHandler
extends Node2D
# Enemy Turns and Actions

func _ready() -> void:
	EventBus.enemy_action_completed.connect(_on_enemy_action_completed)


func setup_enemies(battle_stats: BattleStats) -> void:
	if not battle_stats:
		return
	# Queue-free remnant enemies from another battle
	for enemy: Enemy in get_children(): 
		enemy.queue_free()
	# Store the new enemies from the incoming battle scene as a variable
	var all_new_enemies := battle_stats.enemies.instantiate()
	# Iterate over each new enemy and duplicate their nodes as Enemy nodes for the new scene, add_children to EnemyHandler
	for new_enemy: Node2D in all_new_enemies.get_children():
		var new_enemy_child := new_enemy.duplicate() as Enemy
		add_child(new_enemy_child)
	# Once finished, clear the list so its ready for future use
	all_new_enemies.queue_free()


func reset_enemy_actions() -> void:
	var enemy: Enemy
	for child in get_children():
		enemy = child as Enemy
		enemy.current_action = null
		enemy.update_action()


func start_turn() -> void:
	if get_child_count() == 0:
		return
	
	var first_enemy: Enemy = get_child(0) as Enemy
	first_enemy.do_turn()


func _on_enemy_action_completed(enemy: Enemy) -> void:
	if enemy.get_index() == get_child_count() - 1:
		EventBus.enemy_turn_ended.emit()
		return
	
	var next_enemy: Enemy = get_child(enemy.get_index() + 1) as Enemy
	next_enemy.do_turn()
