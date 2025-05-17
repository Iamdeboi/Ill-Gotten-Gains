class_name InvSlot
extends Button

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_quantity_label: Label = %ItemQuantityLabel

var slot_data: SlotData : set = set_slot_data
var slot_index: int

func _ready() -> void:
	item_icon.texture = null
	item_quantity_label.text = ""
	focus_entered.connect(item_focused)
	focus_exited.connect(item_unfocused)
	pressed.connect(item_pressed)

func set_slot_data(value: SlotData) -> void:
	slot_data = value
	if slot_data == null:
		return
	item_icon.texture = slot_data.item_data.item_texture
	item_quantity_label.text = str(slot_data.quantity)
	if slot_data.item_data.stack_size == 1:
		item_quantity_label.visible = false


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		EventBus.item_clicked.emit(slot_data)
	elif event.is_action_pressed("right_mouse"):
		EventBus.item_clicked_away.emit()


func item_focused() -> void:
	if slot_data != null:
		if slot_data.item_data != null:
			EventBus.item_focused.emit(slot_data)


func item_unfocused() -> void:
	pass


func item_pressed() -> void:
	if slot_data:
		if slot_data.item_data:
			var was_used = slot_data.item_data.use() # Returns true or false depending on if the item has effects
			if was_used == false:
				return
			slot_data.quantity -= 1
			item_quantity_label.text = str(slot_data.quantity)
