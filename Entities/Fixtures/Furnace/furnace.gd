# a usable fixture that the player can smelt ore in

extends Fixture

onready var furnace_ui_scene = preload("res://Entities/Fixtures/Furnace/FurnaceUI.tscn")
onready var furnace_ui_instance = furnace_ui_scene.instance()

func _ready():
	fixture_id = 2
	player_can_use = true
	player_can_open = true

func use(player):
	Server.send_fixture_used(self)
	player.get_node("GUI").add_child(furnace_ui_instance)
	
	for slot in furnace_ui_instance.slots:
		player.available_slots.append(slot)
	
func stop_use(player):
	self.close(player)
	player.get_node("GUI").remove_child(furnace_ui_instance)
	
	for slot in furnace_ui_instance.slots:
		player.available_slots.erase(slot)
