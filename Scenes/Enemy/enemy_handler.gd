class_name EnemyHandler
extends Node2D
# Enemy Turns and Actions

var acting_enemies: Array[Enemy] = [] # An array that refreshes each enemy-turn cycle, denoting which enemies will act on their turns


func _ready() -> void:
	EventBus.enemy_died.connect(_on_enemy_died)
	EventBus.enemy_action_completed.connect(_on_enemy_action_completed)
	EventBus.any_player_action_done.connect(_on_any_player_action_done)


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
		new_enemy_child.status_handler.statuses_applied.connect(_on_enemy_statuses_applied.bind(new_enemy_child))
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
	
	acting_enemies.clear() # Clear array, preparing for turn order and designation for the next enemy turn cycle
	for enemy: Enemy in get_children():
		acting_enemies.append(enemy)
	
	_start_next_enemy_turn()


func _start_next_enemy_turn() -> void:
	if acting_enemies.is_empty():
		EventBus.enemy_turn_ended.emit()
		return
	# Apply Start of Turn Status Effects
	acting_enemies[0].status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)


func _on_enemy_statuses_applied(type: Status.Type, enemy: Enemy) -> void:
	match type:
		Status.Type.START_OF_TURN:
			enemy.do_turn()
		Status.Type.END_OF_TURN:
			acting_enemies.erase(enemy)
			_start_next_enemy_turn()


func _on_enemy_died(enemy: Enemy) -> void:
	remove_child(enemy)
	var is_enemy_turn := acting_enemies.size() > 0
	acting_enemies.erase(enemy)
	
	if is_enemy_turn:
		_start_next_enemy_turn()


func _on_enemy_action_completed(enemy: Enemy) -> void:
	enemy.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)


func _on_any_player_action_done() -> void:
	for enemy: Enemy in get_children():
		enemy.update_intent()
