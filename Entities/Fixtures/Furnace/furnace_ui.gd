extends MarginContainer

onready var slot_scene = preload("res://GUI/InventorySlot.tscn")

onready var material_slots_container = get_node("PanelContainer/HBoxContainer/CenterContainer/GridContainer")
onready var crafted_slot_container = get_node("PanelContainer/HBoxContainer/CenterContainer2")

var slots:Array = []

func _ready(): #TODO make another type of scene with a "crafted slot" that items can't be put into
	var panel_container = get_node("PanelContainer")
	panel_container.add_stylebox_override(Resources.PANEL_CONTAINER_STYLEBOX, panel_container.get_theme().get_stylebox(Resources.UI_BACKGROUND_STYLEBOX, "PanelContainer"))
	
	var slot_instance = slot_scene.instance()
	crafted_slot_container.add_child(slot_instance)
	slots.append(slot_instance)
	
	for i in range(5):
		slot_instance = slot_scene.instance()
		material_slots_container.add_child(slot_instance)
		slots.append(slot_instance)
