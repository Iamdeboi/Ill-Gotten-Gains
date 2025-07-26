# meta-name: Status
# meta-description: Template for a Status, an effect that can be applied to a target (Enemy or Player)
class_name DaStatus
extends Status

var member_var := 0

func get_tooltip() -> String:
	return tooltip


func initialize_status(target: Node) -> void:
	print("Initialize my status for target %s" % target)


func apply_status(target: Node) -> void:
	print("My status targets %s" % target)
	print("It does %s something" % member_var)
	
	status_applied.emit(self)
