extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 56089

var is_connected = false
var client_map
var client_player

func _ready():
	connect_to_server()

func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")

func _on_connection_succeeded():
	is_connected = true
	print("Succesfully connected")

func _on_connection_failed():
	print("Failed to connect")

# map
func set_map(map):
	client_map = map
	network.connect("connection_succeeded", client_map, "_on_connection_succeeded")

#player
func set_player(player):
	client_player = player
	network.connect("connection_succeeded", client_player, "_on_connection_succeeded")

# player states
func send_player_state(player_state):
	rpc_unreliable_id(1, "receive_player_state", player_state)

remote func receive_world_state(s_world_state): # {id:{d, p}}
	client_map.update_world_state(s_world_state)

remote func receive_player_stats(s_stats): #{s}
	client_player.update_stats(s_stats)

# player interaction
func send_item_picked_up(item):
	rpc_id(1, "receive_item_picked_up", item.get_id(), item.get_position())

func send_item_dropped(item_id):
	rpc_id(1, "receive_item_dropped", item_id)

func send_fixture_used(fixture):
	rpc_id(1, "receive_fixture_used", fixture.get_id(), fixture.get_position(), fixture.get_instance_id())

# items
func fetch_spawned_items():
	rpc_id(1, "fetch_spawned_items")

remote func receive_spawned_items(s_items):
	client_map.set_spawned_items(s_items)

remote func receive_spawned_item(item_id: int, item_pos):
	print("wut")
	client_map.spawn_item(item_id, item_pos)

remote func receive_item_picked_up(player_id, item_id, item_pos):
	client_map.despawn_item(item_id, item_pos)
	if get_tree().get_network_unique_id() == player_id:
		client_player.receive_item(item_id)
