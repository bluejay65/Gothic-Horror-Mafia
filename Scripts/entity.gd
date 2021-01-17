# player_can_use determines whether or not a player can select and use the item (default: false)
# every entity that can be used need a _use function

extends Node2D
class_name Entity

var player_can_use: bool = false #to create the function for usablity, use "_use()"
onready var usable_shader_material = preload("res://Resources/outline_shader_material.tres")
signal show_usable
signal hide_usable
signal use(player)

func _ready():
	add_to_group("entities")
	connect("show_usable", self, "_show_usable")
	connect("hide_usable", self, "_hide_usable")
	connect("use", self, "_use")

func _show_usable():
	get_node("Sprite").get_material().set_shader_param("outline_color", Color(1, 1, 1, 1))

func _hide_usable():
	get_node("Sprite").get_material().set_shader_param("outline_color", Color(0, 0, 0, 1))
