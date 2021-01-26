extends FixtureUI #TODO maybe make this entire thing a JSON file, but probably not

var silver_materials:Dictionary = {3: 1} # 1 silver ore TODO definetly make this a JSON file
var silver_crafted:Dictionary = {2: 1} # 1 silver

func _ready():
	material_slots_container = get_node("PanelContainer/HBoxContainer/CenterContainer/GridContainer")
	crafted_slots_container = get_node("PanelContainer/HBoxContainer/CenterContainer2/GridContainer")
	fuel_slots_container = get_node("PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer")
	num_material_slots = 1
	num_crafted_slots = 1
	num_fuel_slots = 1
	
	crafting_recipes[silver_crafted] = silver_materials
	
	self.setup()
