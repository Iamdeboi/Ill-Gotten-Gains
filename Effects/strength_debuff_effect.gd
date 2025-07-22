# meta_description: Debuff's target's strength by a defined value
class_name StrengthDebuffEffect
extends Effect

var amount := 0


func execute(targets: Array[Node], _ability: Ability, _p_s_mod: float, _s_s_mod: float) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.stats.strength -= amount
			target.stats.stats_changed.emit()
			SfxPlayer.play(sound)
