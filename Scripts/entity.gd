# player_can_use determines whether or not a player can select and use the entity (default: false)
# every entity that can be used need a use function

extends Node2D
class_name Entity

var player_can_use: bool = false #to create the function for usablity, use "_use()"

func _ready():
	add_to_group("entities")

func show_usable():
	get_node("Sprite").get_material().set_shader_param("outline_color", Color(1, 1, 1, 1))

func hide_usable():
	get_node("Sprite").get_material().set_shader_param("outline_color", Color(0, 0, 0, 1))
