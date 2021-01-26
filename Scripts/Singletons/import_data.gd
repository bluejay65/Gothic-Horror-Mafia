#TODO let the player store the id's name and sprite in their own json, but save everything else on the server

# load_json_file(file_path):
# takes a json file path and returns a dictionary

# dict_keys_to_int(dict_old):
# returns a dictionary with integer keys, based off a dictionary with non-integer keys


extends Node

var client_item_data #dictionary that holds the client-side item data

func _ready():
	var json_data = load_json_file("res://Data/ItemData - ClientItemData.json") #saves the json file as a dictionary
	client_item_data = dict_keys_to_int(json_data) #changes all the keys to integers

# takes a json file path and returns a dictionary
func load_json_file(file_path):
	var data_file = File.new()
	var data_json
	data_file.open(file_path, File.READ)
	data_json = JSON.parse(data_file.get_as_text())
	data_file.close()
	return data_json.result

# returns a dictionary with integer keys, based off a dictionary with non-integer keys
func dict_keys_to_int(dict_old:Dictionary):
	var dict_new:Dictionary = {}
	for key in dict_old.keys():
		dict_new[int(key)] = dict_old[key]
	return dict_new


# Functions to get client-side item data
func get_sprite(item_id:int): #TODO determine if load or preload is faster
	return load(client_item_data[item_id]["ItemSpritePath"])

func get_item_name(item_id:int):
	return client_item_data[item_id]["ItemName"]


# Functions to get server-side item data
func get_scene(item_id:int):
	return load(client_item_data[item_id]["ItemScenePath"])

func get_fuel_time(item_id:int, requester_id):
	Server.fetch_fuel_time(item_id, requester_id)
