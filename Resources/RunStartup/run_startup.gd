class_name RunStartup
extends Resource
# Stores data about the run's type and the selected character data,
# which will be saved and referenced in the run_scene

enum Type {NEW_RUN, CONTINUED_RUN}

@export var type: Type
@export var selected_character: PlayerStats
