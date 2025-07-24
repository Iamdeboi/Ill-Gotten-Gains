extends Node

# Player-related Events
signal player_hotbar_loaded
signal player_turn_started
signal player_turn_ended
signal player_end_turn_delay_elasped
signal player_died
signal player_stats_changed
signal player_attributes_changed

# Enemy-related Events
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended
signal enemy_died(enemy: Enemy)

# Ability-related Events
signal ability_drag_started(ability_slot: AbilitySlot)
signal ability_drag_ended(ability_slot: AbilitySlot)
signal ability_targeting_started(ability_slot: AbilitySlot)
signal ability_targeting_ended(ability_slot: AbilitySlot)
signal any_player_action_done
signal ability_used(ability: Ability)
signal ability_tooltip_requested(ability: Ability)
signal tooltip_hide_requested
signal ability_cooldown_started(ability: Ability)
signal ability_cooldown_ended(ability: Ability)


# Map-related Events
signal map_exited(room: Room)

# Shop-related Events
signal shop_exited

# Combat-related Events
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal battle_won
signal status_effect_toolip_requested(statuses: Array[Status])

# Combat-rewards Events
signal battle_reward_exited

# Treaure-related Events
signal treasure_room_exited

#Campfire Related Events
signal campfire_exited
