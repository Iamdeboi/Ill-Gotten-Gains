extends Node

# Player-related Events
signal player_turn_ended

# Enemy-related Events
signal enemy_action_completed(enemy: Enemy)

# Ability-related Events
signal ability_used(ability: Ability)
signal ability_targetting_started()
signal ability_targetting_ended()
signal ability_tooltip_requested(ability: Ability)
signal tooltip_hide_requested

# Map-related Events
signal map_exited(room: Room)

# Shop-related Events
signal shop_exited

# Combat-related Events
#signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal battle_won

# Combat-rewards Events
signal battle_reward_exited

# Treaure-related Events
signal treasure_room_exited

#Campfire Related Events
signal campfire_exited
