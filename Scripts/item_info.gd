# item_ids is a dictionary with all the item SCENEs and scripts saved under an id
# to access item use ItemInfo.item_ids[id][ItemInfo.SCENE/SPRITE]
# instanced_item can be called from ItemInfo with an id parameter
# spawn spawns an item from an id at a position

# list of item ids:
# 1: Coal
# 2: Silver
# 3: Silver Ore

extends Node

const SCENE = 0

const SPRITE = 1

const ITEM_NAME = 2

const FUEL_TIME = 3
var default_fuel_time = 0

const item_ids:Dictionary = {-1: {SCENE: null, SPRITE: null, ITEM_NAME: ""},
	1: {SCENE: preload("res://Entities/Items/Coal/Coal.tscn"), SPRITE: preload("res://Entities/Items/Coal/coal.png"), ITEM_NAME: "Coal", FUEL_TIME: 1},
	2: {SCENE: preload("res://Entities/Items/Silver/Silver.tscn"), SPRITE: preload("res://Entities/Items/Silver/silver.png"), ITEM_NAME: "Silver"},
	3: {SCENE: preload("res://Entities/Items/SilverOre/SilverOre.tscn"), SPRITE: preload("res://Entities/Items/SilverOre/silver_ore.png"), ITEM_NAME: "Silver Ore"},} #TODO figure out if load() or preload() is faster

func get_scene(id:int):
	return item_ids[id][SCENE]
	
func get_sprite(id:int):
	return item_ids[id][SPRITE]
	
func get_item_name(id:int):
	return item_ids[id][ITEM_NAME]

func get_fuel_time(id:int):
	if item_ids[id].has(FUEL_TIME):
		return item_ids[id][FUEL_TIME]
	return default_fuel_time

func instanced_item(id:int):
	var instance = get_scene(id).instance()
	return instance

func spawn(id:int, pos:Vector2):
	var item = instanced_item(id)
	get_node("/root/Map").add_child(item)
	item.set_position(pos)

func slots_to_dict(slots: Array): # converts an array of slots to a dictionary with the form {item1_id: number_of_item1, item2_id: number_of_item2}
	var dict:Dictionary = {}
	for slot in slots:
		if dict.has(slot):
			dict[slot.item] += slot.num_items
		else:
			dict[slot.item] = slot.num_items
	return dict
	
func has_open_slot(slots: Array):
	var has_open = false
	for slot in slots:
		if slot.item <= 0:
			has_open = true
			break
	return has_open

func first_open_slot(slots: Array):
	for slot in slots:
		if slot.item <= 0:
			return slot
	return null
	
func can_add_items(items: Dictionary, slots: Array):
	var num_empty_slots = 0
	var ids = items.values()
	
	for slot in slots:
		if slot.has_item():
#			for i in range(item_ids.size()):
#				if item_ids[i] == slot.item:
#					ids.remove(i)
			pass
		else:
			num_empty_slots += 1
	if ids.size() <= num_empty_slots:
		return true
	return false

