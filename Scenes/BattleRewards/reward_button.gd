class_name RewardsButton
extends Button

@export var reward_icon : Texture : set = _set_reward_icon
@export var reward_text : String : set = _set_reward_text

@onready var custom_icon: TextureRect = %CustomIcon
@onready var custom_text: Label = %CustomText


func _set_reward_icon(new_icon: Texture) -> void:
	reward_icon = new_icon
	
	if not is_node_ready():
		await ready
	
	custom_icon.texture = reward_icon


func _set_reward_text(new_text: String) -> void:
	reward_text = new_text
	
	if not is_node_ready():
		await ready
	
	custom_text.text = reward_text

func _on_pressed() -> void:
	queue_free() # Queue the reward button free to act like the reward is claimed
