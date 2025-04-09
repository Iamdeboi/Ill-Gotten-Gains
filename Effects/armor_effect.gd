class_name ArmorEffect
extends Effect

var amount := 0


func execute(targets: Array[Node], ability: Ability, primary_scaling_mod: float, secondary_scaling_mod: float) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			print("Amount: " + str(amount))
			amount += primary_scaling_mod + secondary_scaling_mod
			print("Primary Scaling Mod: " + str(primary_scaling_mod))
			print("Secondary Scaling Mod: " + str(secondary_scaling_mod))
			print("Calculated Amount: " + str(amount))
			target.stats.restore_armor(amount)
			SfxPlayer.play(sound)
