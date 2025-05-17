class_name ItemEffectHeal
extends ItemEffect

@export var healing_amount : int = 1
@export var sound : AudioStream


func use() -> void:
	PlayerInventory.run_node.character.heal(healing_amount)
	SfxPlayer.play(sound)
