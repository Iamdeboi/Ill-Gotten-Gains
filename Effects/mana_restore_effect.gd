class_name ManaRestoreEffect
extends Effect

var amount := 0


func execute(targets: Array[Node], ability: Ability, primary_scaling_mod: float, secondary_scaling_mod: float) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.stats.mana += amount
			SfxPlayer.play(sound)
