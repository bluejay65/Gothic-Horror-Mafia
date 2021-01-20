extends FixtureUI

var silver_materials:Dictionary = {3: 1} # 1 silver ore
var silver_crafted:Dictionary = {2: 1} # one silver

func _ready(): #TODO make another type of scene with a "crafted slot" that items can't be put into
	material_slots_container = get_node("PanelContainer/HBoxContainer/CenterContainer/GridContainer")
	crafted_slots_container = get_node("PanelContainer/HBoxContainer/CenterContainer2/GridContainer")
	fuel_slots_container = get_node("PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer")
	num_material_slots = 1
	num_crafted_slots = 1
	num_fuel_slots = 1
	
	crafting_recipes[silver_crafted] = silver_materials
	
	self.setup()
