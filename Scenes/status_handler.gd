class_name StatusHandler
extends Container

signal statuses_applied(type: Status.Type)

const STATUS_APPLY_INTERVAL := 0.25
const STATUS_UI = preload("res://Scenes/StatusHandler/status_ui.tscn")

@export var status_owner: Node #Player or Enemy node


func apply_statuses_by_type(type: Status.Type) -> void:
	if type == Status.Type.EVENT_BASED:
		return
	# Create Status Queue that is filtered by their Type
	var status_queue: Array[Status] = _get_all_statuses().filter(
		func(status: Status):
			return status.type == type
	)
	if status_queue.is_empty():
		statuses_applied.emit(type) # If empty, emit signal and continue on with combat loop
		return
	
	var tween := create_tween()
	for status: Status in status_queue:
		tween.tween_callback(status.apply_status.bind(status_owner))
		tween.tween_interval(STATUS_APPLY_INTERVAL)
	
	tween.finished.connect(func(): statuses_applied.emit(type))


func add_status(status: Status) -> void:
	var stackable := status.stack_type != Status.StackType.NONE
	
	# Add a new StatusUI child if its a new type
	if not _has_status(status.id):
		var new_status_ui := STATUS_UI.instantiate() as StatusUI
		add_child(new_status_ui)
		new_status_ui.status = status
		new_status_ui.status.status_applied.connect(_on_status_applied)
		new_status_ui.status.initialize_status(status_owner)
		return
	
	# If it's unique and already have it within the handler, return
	if not status.can_expire and not stackable:
		return
	
	# If it's both duration and intensity-stackable, increase duration and stacks
	if status.can_expire and status.stack_type == Status.StackType.BOTH:
		_get_status(status.id).duration += status.duration
		_get_status(status.id).stacks += status.stacks
	
	# If it's only duration-stackable, expand it
	if status.can_expire and status.stack_type == Status.StackType.DURATION:
		_get_status(status.id).duration += status.duration
		return
	
	# If it's only intensity-stackable, stack it
	if status.stack_type == Status.StackType.INTENSITY:
		_get_status(status.id).stacks += status.stacks


func _has_status(id: String) -> bool:
	for status_ui: StatusUI in get_children():
		if status_ui.status.id == id:
			return true
	
	return false


func _get_status(id: String) -> Status:
	for status_ui: StatusUI in get_children():
		if status_ui.status.id == id:
			return status_ui.status
	
	return null


func _get_all_statuses() -> Array[Status]:
	var statuses: Array[Status] = []
	for status_ui: StatusUI in get_children():
		statuses.append(status_ui.status)
	
	return statuses


func _on_status_applied(status: Status) -> void:
	if status.can_expire:
		status.duration -= 1

# On left clicking the statushandler UI, send a signal globally containing the Array[Status] of that status handler; used for StatusTooltips
func _on_gui_input(event: InputEvent) -> void: 
	if event.is_action_pressed("left_mouse"):
		EventBus.status_effect_toolip_requested.emit(_get_all_statuses())
