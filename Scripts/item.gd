# base class for every item on the map

# item_id needs to match with the item_id in item_info

# use(player):
# lets the player pick up an item if the player has open slots

extends Entity
class_name Item

var item_id:int = -1

func _ready():
	player_can_use = true

# lets the player pick up an item if the player has open slots
func use(player):
	if player.gui.has_open_player_slot():
		player.pick_up(self)

func get_id():
	return item_id
