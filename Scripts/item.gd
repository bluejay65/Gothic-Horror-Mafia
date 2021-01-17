# every item needs an id and item_name declared
# id needs to match with the id in item_info
# to access item use ItemInfo.item_ids[id][ItemInfo.scene/sprite]
# _use lets the player pick up the item if their inventory has space
# spawn spawns the item at the position parameter
# instanced_item returns an instance of this item

extends Entity
class_name Item

var id = null
var item_name = null

func _ready():
	player_can_use = true

func _use(player):
	if player.inventory.size() < player.max_inventory_size:
		player.pick_up(self.id)
		queue_free()
