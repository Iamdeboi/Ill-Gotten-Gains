extends Ability

@export var optional_sound: AudioStream


func apply_effects(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float) -> void:
	print("The ability has been played")
	print("Targets: %s" % targets)
