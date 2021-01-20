extends MarginContainer
class_name FixtureUI

onready var slot_scene = preload("res://GUI/InventorySlot.tscn")

var background_stylebox = Resources.UI_BACKGROUND_STYLEBOX

var num_material_slots:int = 0
var num_crafted_slots:int = 0
var num_fuel_slots:int = 0

var material_slots_container = null
var crafted_slots_container = null
var fuel_slots_container = null

var needs_fuel:bool = false
var is_fueled:bool = false

var slots:Array = []
var material_slots:Array = []
var crafted_slots:Array = []
var crafting_recipes:Dictionary = {} # Recipes are created with; {{crafted_item1_id: number_of_item1_crafted, crafted_item2_id: number_of_item2_crafted}: {material_item1_id: number_of_material1_required, material_item2_id: number_of_material2_required}}

func setup(): #TODO make another type of scene with a "crafted slot" that items can't be put into
	var panel_container = get_node("PanelContainer")
	panel_container.add_stylebox_override(Resources.PANEL_CONTAINER_STYLEBOX, panel_container.get_theme().get_stylebox(Resources.UI_BACKGROUND_STYLEBOX, "PanelContainer"))
	
	if num_fuel_slots > 0:
		needs_fuel = true
	
	for i in range(num_material_slots):
		var slot_instance = slot_scene.instance()
		material_slots_container.add_child(slot_instance)
		slots.append(slot_instance)
		material_slots.append(slot_instance)
		slot_instance.connect("item_added", self, "_on_material_added")
	
	for i in range(num_crafted_slots):
		var slot_instance = slot_scene.instance()
		slot_instance.is_locked = true
		crafted_slots_container.add_child(slot_instance)
		slots.append(slot_instance)
		crafted_slots.append(slot_instance)
		
	for i in range(num_fuel_slots):
		var slot_instance = slot_scene.instance()
		fuel_slots_container.add_child(slot_instance)
		slots.append(slot_instance)
		slot_instance.connect("item_added", self, "_on_fuel_added", [slot_instance])

func _on_material_added():
	var recipe_key = craftable()
	
	if recipe_key != null:
		print("true")
		craft(recipe_key)

func _on_fuel_added(slot): #TODO: when multiplayer is added, get the timers working correctly
	var fuel_time = ItemInfo.get_fuel_time(slot.item)
	if fuel_time > 0:
		slot.remove_item()
		is_fueled = true
		_on_material_added()

func craftable():
	if !(needs_fuel and !is_fueled):
		var material_items = ItemInfo.slots_to_dict(material_slots)
	
		for recipe_key in crafting_recipes.keys():
			if material_items.has_all(crafting_recipes[recipe_key].keys()):
				for id in crafting_recipes[recipe_key].keys():
					if material_items[id] >= crafting_recipes[recipe_key][id]:
						if ItemInfo.can_add_items(crafting_recipes[recipe_key], crafted_slots):
							return recipe_key
	return null
	
func craft(recipe_key):
	for slot in material_slots:
		for id in crafting_recipes[recipe_key].keys():
			if slot.item == id:
				slot.subtract_items(crafting_recipes[recipe_key][id])
	
	for id in recipe_key.keys():
		var item_added = false
		for slot in crafted_slots:
			if slot.is_item(id):
				slot.add_items(recipe_key[id])
				item_added = true
		if item_added == false:
			ItemInfo.first_open_slot(crafted_slots).set_item_num(id, recipe_key[id])
