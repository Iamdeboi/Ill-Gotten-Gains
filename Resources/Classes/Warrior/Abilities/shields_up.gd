extends Ability


func apply_effects(targets: Array[Node]) -> void:
	var armor_effect := ArmorEffect.new()
	armor_effect.amount = 10
	armor_effect.execute(targets)
