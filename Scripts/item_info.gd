# item_ids is a dictionary with all the item scenes and scripts saved under an id
# to access item use ItemInfo.item_ids[id][ItemInfo.scene/sprite]
# instanced_item can be called from ItemInfo with an id parameter
# spawn spawns an item from an id at a position

extends Node

const scene = 0
const sprite = 1
const item_name = 2

const item_ids:Dictionary = {1: {scene: preload("res://Items/Coal/Coal.tscn"), sprite: preload("res://Items/Coal/coal.png"), item_name: "Coal"}} #TODO figure out if load() or preload() is faster

func instanced_item(id:int):
	var instance = item_ids[id][scene].instance()
	return instance

func spawn(id:int, pos:Vector2):
	var item = instanced_item(id)
	get_node("/root/Map").add_child(item)
	item.set_position(pos)
