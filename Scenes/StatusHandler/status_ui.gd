class_name StatusUI
extends Control

@export var status: Status : set = set_status

@onready var icon: TextureRect = $Icon
@onready var duration: Label = $Duration
@onready var stacks: Label = $Stacks


func set_status(new_status: Status) -> void:
	if not is_node_ready():
		await ready
	
	status = new_status
	icon.texture = status.icon
	match status.stack_type:
		Status.StackType.DURATION:
			duration.visible = true
			stacks.visible = false
		Status.StackType.INTENSITY:
			duration.visible = false
			stacks.visible = true
		Status.StackType.BOTH:
			duration.visible = true
			stacks.visible = true
		_:
			duration.visible = false
			stacks.visible = false
	#duration.visible = status.stack_type == Status.StackType.DURATION or Status.StackType.BOTH
	#stacks.visible = status.stack_type ==  Status.StackType.INTENSITY or Status.StackType.BOTH
	custom_minimum_size = icon.size
	
	if duration.visible:
		custom_minimum_size = duration.size + duration.position
	elif stacks.visible:
		custom_minimum_size = stacks.size + stacks.position
	
	if not status.status_changed.is_connected(_on_status_changed):
		status.status_changed.connect(_on_status_changed)
	
	_on_status_changed()


func _on_status_changed() -> void:
	if not status:
		return
		
	# Status Type: Both
	if status.can_expire and status.stack_type == Status.StackType.BOTH and status.duration <= 0:
		queue_free()
		
	#Status Type: Duration
	if status.can_expire and status.stack_type == Status.StackType.DURATION and status.duration <= 0:
		queue_free()
	
	# Status Type: Intensity
	if status.stack_type == Status.StackType.INTENSITY and status.stacks == 0: # Negative Values possible (Debuff)
		queue_free()
	
	duration.text = str(status.duration)
	stacks.text = str(status.stacks)
