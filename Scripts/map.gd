extends TileMap

var other_player_scene = preload("res://Players/PlayerTemplate.tscn")
var client_player_scene = preload("res://Players/Player.tscn")

signal map_set

const ITEM_ID = 0
const ITEM_POS = 1

onready var client_player = get_node("Player")
var other_players: Dictionary = {}
var spawned_items: Array = []

var last_world_state_update = 0

func _ready():
	Server.set_map(self)

func _on_connection_succeeded():
	Server.fetch_spawned_items()

func set_spawned_items(s_spawned_items:Array): #TODO see if you should make it spawn all the same items at the same time, so it doesn't have to load the same scene a bunch of times
	for item in s_spawned_items:
		spawn_item(item[ITEM_ID], item[ITEM_POS])

func spawn_item(item_id, item_pos):
	var item_scene = ImportData.get_scene(item_id).instance()
	item_scene.set_position(item_pos)
	add_child(item_scene)
	spawned_items.append(item_scene)

func despawn_item(item_id, item_pos):
	var possible_items: Array = []
	for item in spawned_items:
		if item.get_id() == item_id:
			possible_items.append(item)
	for i in range(possible_items.size()):
		if possible_items[i].get_position() == item_pos:
			spawned_items.erase(possible_items[i])
			possible_items[i].free()
			break

func spawn_client_player(player_id):
	client_player = client_player_scene.instance()
	add_child(client_player)

func update_client_player_state(player_state):
	client_player.set_position(player_state["p"])

func spawn_other_player(player_id):
	var player = other_player_scene.instance()
	other_players[player_id] = player
	add_child(player)

func update_other_player_state(player_id, player_state):
	other_players[player_id].set_position(player_state["p"])

func update_world_state(world_state):
	if world_state.has("t") and last_world_state_update < world_state["t"]:
		last_world_state_update = world_state["t"]
		world_state.erase("t")
		
		var client_player_state = world_state[get_tree().get_network_unique_id()]
		update_client_player_state(client_player_state)
		
		var other_players_states = world_state.duplicate(true)
		other_players_states.erase(get_tree().get_network_unique_id())
		for player_id in other_players_states.keys():
			if !other_players.has(player_id):
				spawn_other_player(player_id)
			update_other_player_state(player_id, other_players_states[player_id])
