class_name Events
extends Node

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
