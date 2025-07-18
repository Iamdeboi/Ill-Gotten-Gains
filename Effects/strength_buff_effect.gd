# meta_description: Buffs target's strength by a defined value
class_name StrengthBuffEffect
extends Effect

var amount := 0


func execute(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			print("Amount: " + str(amount))
			print("Primary Scaling Mod: " + str(p_s_mod))
			print("Secondary Scaling Mod: " + str(s_s_mod))
			print("Calculated Amount: " + str(amount))
			target.stats.strength += amount
			target.stats.stats_changed.emit()
			SfxPlayer.play(sound)
