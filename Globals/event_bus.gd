class_name Events
extends Node

# Player-related Events
signal player_turn_ended

# Enemy-related Events
signal enemy_action_completed(enemy: Enemy)

# Map-related Events
signal map_exited

# Shop-related Events
signal shop_exited

# Combat-related Events
#signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal battle_won

# Combat-rewards Events
signal battle_reward_exited

# Treaure-related Events
signal treasure_room_exited
