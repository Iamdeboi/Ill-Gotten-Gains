class_name DamageEffect
extends Effect

var amount := 0


func execute(targets: Array[Node], ability: Ability, primary_scaling_mod: float, secondary_scaling_mod: float) -> void:
	for target in targets:
		if not target:
			continue
			
		if target is Enemy or target is Player:
			var dmg_mod: float = 1
			var element = ability.element_type
			
			# Elemental Damage Mod
			match ability.element_type:
				0: # None
					dmg_mod = 1
				1: # Physical
					dmg_mod = target.stats.physical_vuln
				2: # Fire
					dmg_mod = target.stats.fire_vuln
				3: # Frost
					dmg_mod = target.stats.frost_vuln
				4: # Storm
					dmg_mod = target.stats.storm_vuln
				5: # Toxic
					dmg_mod = target.stats.toxic_vuln
				6: # Arcane
					dmg_mod = target.stats.arcane_vuln
				7: # Shadow
					dmg_mod = target.stats.shadow_vuln
				8: # Holy
					dmg_mod = target.stats.holy_vuln
			
			var damage = target.calculate_damage(amount, dmg_mod, primary_scaling_mod, secondary_scaling_mod)
			print("Amount: " + str(amount))
			print("Damage Mod: " + str(dmg_mod))
			print("Primary Scaling Mod: " + str(primary_scaling_mod))
			print("Secondary Scaling Mod: " + str(secondary_scaling_mod))
			print("Calculated Damage: " + str(damage))
			print("====-----------------====")
			target.take_damage(damage)
