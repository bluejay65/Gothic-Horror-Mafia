# fixture_ui controls the gui of any fixture on the map

# setup():
# sets up the background, determines if fuel is needed, and instances all the material, crafted, and fuel slots

# _on_material_added():
# when a material is added, check if an item can be crafted

# _on_fuel_added(slot):
# when an item is added to a fuel slot, check if that item adds fuel time, and if it does, add that time to the fuel timer

# craftable():
# checks if a recipe for this fixture can be fulfilled and returns the key to that recipe

# craft(recipe_key):
# assumes that the recipe can be crafted; subtracts all the materials used in crafted and adds the crafted items to the crafted slots


extends MarginContainer
class_name FixtureUI

onready var slot_scene = preload("res://GUI/InventorySlot.tscn") #scene for the slots that items can go in

var background_stylebox = Resources.UI_BACKGROUND_STYLEBOX #the default background for any fixture ui

var num_material_slots:int = 0 #the number of slots that crafting items can be put in; can also be used for storage
var num_crafted_slots:int = 0 #the number of slots that crafted items will pop out in; will be locked
var num_fuel_slots:int = 0 #the number of slots fuel can be placed in

var material_slots_container = null #the container node that will parent the material slots
var crafted_slots_container = null #the container node that will parent the crafted slots
var fuel_slots_container = null #the container node that will parent the fuel slots

var needs_fuel:bool = false #whether or not the fixture needs to be fueled to craft
var is_fueled:bool = false #whether or not the fixture is fueled TODO: make this based off whether or not a fuel timer is going or not

var slots:Array = [] #holds all the slot nodes in the ui; not sure what it's used for
var material_slots:Array = [] #holds all the material slot nodes in the ui; used to determine if something can be crafted (has enough materials or not)
var crafted_slots:Array = [] #holds all the crafted slot nodes in the ui; used to determine if something can be crafted (has space or not)
var crafting_recipes:Dictionary = {} #Recipes are created with; {{crafted_item1_item_id: number_of_item1_crafted, crafted_item2_item_id: number_of_item2_crafted}: {material_item1_item_id: number_of_material1_required, material_item2_item_id: number_of_material2_required}}

# sets up the background, determines if fuel is needed, and instances all the material, crafted, and fuel slots
func setup():
	var panel_container = get_node("PanelContainer")
	panel_container.add_stylebox_override(Resources.PANEL_CONTAINER_STYLEBOX, panel_container.get_theme().get_stylebox(background_stylebox, "PanelContainer")) #sets the background stylebox of the ui to be the default background
	
	if num_fuel_slots > 0: #if there is at least one fuel slot, the fixture needs fuel
		needs_fuel = true
	
	# creates the material slots
	for _i in range(num_material_slots):
		var slot_instance = slot_scene.instance()
		material_slots_container.add_child(slot_instance)
		slots.append(slot_instance)
		material_slots.append(slot_instance)
		slot_instance.connect("item_added", self, "_on_material_added")
	
	# creates the crafted slots
	for _i in range(num_crafted_slots):
		var slot_instance = slot_scene.instance()
		slot_instance.is_locked = true
		crafted_slots_container.add_child(slot_instance)
		slots.append(slot_instance)
		crafted_slots.append(slot_instance)
	
	# creates the fuel slots
	for _i in range(num_fuel_slots):
		var slot_instance = slot_scene.instance()
		fuel_slots_container.add_child(slot_instance)
		slots.append(slot_instance)
		slot_instance.connect("item_added", self, "_on_fuel_added", [slot_instance]) #there doesn't have to be an array for fuel slots, because the fuel is automatically added to the fuel time

# when a material is added, check if an item can be crafted, and then craft it
func _on_material_added():
	if num_crafted_slots > 0: #check if this fixture has crafting before trying to craft
		var recipe_key = craftable() #figures out if an item can be crafted and returns it
		if recipe_key != null:
			craft(recipe_key) #subtracts the materials used and adds the crafted item

# when an item is added to a fuel slot, check if that item adds fuel time, and if it does, add that time to the fuel timer
func _on_fuel_added(slot): #TODO: when multiplayer is added, get the timers working correctly
	var fuel_time = 1
	if fuel_time > 0:
		slot.remove_item() #TODO only remove one item at a time, make the timer just change based off on what items are in the fuel slot (add an on_fuel_subtracted signal)
		is_fueled = true
		_on_material_added() #calls _on_material_added to check if anything can be crafted with the addition of fuel TODO make this called only when is_fueled changes to true

# checks if a recipe for this fixture can be fulfilled and returns the key to that recipe
func craftable():
	if !(needs_fuel and !is_fueled): #verifies that if the fixture needs fuel, it has fuel
		var material_items = Helper.slots_to_dict(material_slots) #creates an array of items out of all the items in the material slots
		
		# loops through every recipe in crafting_recipes using the keys
		for recipe_key in crafting_recipes.keys():
			if material_items.has_all(crafting_recipes[recipe_key].keys()): #verifies that the items needed for materials are in the material slots
				for item_id in crafting_recipes[recipe_key].keys(): #loops through all the items in the material slots
					if material_items[item_id] >= crafting_recipes[recipe_key][item_id]: #verifies that there are enough items for every material in the recipe
						if Helper.can_add_items(crafting_recipes[recipe_key], crafted_slots): #verifies that there is space in the crafted slots to add the crafted items
							return recipe_key #returns the key to the recipe that can be crafted
	return null #if no item can be crafted, returns null

# assumes that the item can be crafted; subtracts all the materials used in crafted and adds the crafted items to the crafted slots
func craft(recipe_key):
	for slot in material_slots: #loops through every material slot
		for item_id in crafting_recipes[recipe_key].keys(): #loops through every item needed for the materials
			if slot.item == item_id: #if the slot has the same item needed to craft the item
				slot.subtract_items(crafting_recipes[recipe_key][item_id]) #subtract the required amount of items to craft the recipe
				break #only subtract the items from one material slot
	
	# loops through all the items that are crafted
	for item_id in recipe_key.keys(): #TODO change all this and the way it checks if items can be crafted; there shouldn't be able to be stacked items in the crafted slots
		var item_added = false
		for slot in crafted_slots: #loops through all the crafted slots
			if slot.is_item(item_id): #checks if that slot already holds the item being crafted
				slot.add_items(recipe_key[item_id]) #adds the amount of items crafted to that slot
				item_added = true
		if item_added == false: #if there wasn't a slot that already held this item
			Helper.first_open_slot(crafted_slots).set_item_num(item_id, recipe_key[item_id]) #set the first open slot to be the item crafted
