# item_ids is a dictionary with all the item SCENEs and scripts saved under an id
# to access item use ItemInfo.item_ids[id][ItemInfo.SCENE/SPRITE]
# instanced_item can be called from ItemInfo with an id parameter
# spawn spawns an item from an id at a position

extends Node

const SCENE = 0
const SPRITE = 1
const ITEM_NAME = 2

const item_ids:Dictionary = {-1: {SCENE: null, SPRITE: null, ITEM_NAME: ""},
	1: {SCENE: preload("res://Entities/Items/Coal/Coal.tscn"), SPRITE: preload("res://Entities/Items/Coal/coal.png"), ITEM_NAME: "Coal"},
	2: {SCENE: preload("res://Entities/Items/Silver/Silver.tscn"), SPRITE: preload("res://Entities/Items/Silver/silver.png"), ITEM_NAME: "Silver"},
	3: {SCENE: preload("res://Entities/Items/SilverOre/SilverOre.tscn"), SPRITE: preload("res://Entities/Items/SilverOre/silver_ore.png"), ITEM_NAME: "Silver Ore"},} #TODO figure out if load() or preload() is faster

func instanced_item(id:int):
	var instance = item_ids[id][SCENE].instance()
	return instance

func spawn(id:int, pos:Vector2):
	var item = instanced_item(id)
	get_node("/root/Map").add_child(item)
	item.set_position(pos)
