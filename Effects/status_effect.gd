# meta_description: Create an effect which applies a status_effect to a target.
class_name StatusEffect
extends Effect

var status: Status


func execute(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player: # Enemy and Player have StatusHandler components
			target.status_handler.add_status(status)
