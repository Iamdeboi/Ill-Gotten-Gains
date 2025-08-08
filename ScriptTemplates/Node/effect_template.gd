# meta-name: Effect
# meta_description: Create an effect which can be applied to a target.
class_name CustomEffect #Rename this class_name to the intended Effect name
extends Effect

var member_var := 0


func execute(targets: Array[Node], ability: Ability, p_s_mod: float, s_s_mod: float) -> void:
	print("My effect targets them: %s" % targets)
	print("It does %s something" % member_var)
