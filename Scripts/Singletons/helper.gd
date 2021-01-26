#TODO replate this singleton with a parent class for everything that uses it

extends Node

func instanced_item(item_id:int):
	var instance = ImportData.get_scene(item_id).instance()
	return instance

func slots_to_dict(slots: Array): # converts an array of slots to a dictionary with the form {item1_item_id: number_of_item1, item2_item_id: number_of_item2}
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
		if !slot.has_item():
			has_open = true
			break
	return has_open

func first_open_slot(slots: Array):
	for slot in slots:
		if !slot.has_item():
			return slot
	return null
	
func can_add_items(items: Dictionary, slots: Array):
	var num_empty_slots = 0
	var item_ids = items.values()
	
	for slot in slots:
		if slot.has_item():
#			for i in range(item_data.size()):
#				if item_data[i] == slot.item:
#					item_ids.remove(i)
			pass
		else:
			num_empty_slots += 1
	if item_ids.size() <= num_empty_slots:
		return true
	return false
