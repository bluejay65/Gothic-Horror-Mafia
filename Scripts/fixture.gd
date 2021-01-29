# player_can_open determines whether or not a player can select and open the ui of the fixture (default: false)
# every fixture that can be opened need a close function
# need to match fixture root node's name with JSON

extends Entity
class_name Fixture

var fixture_id: int = -1
var player_can_open:bool = false
	
func close(player):
	player.fixture_opened = null

func get_id():
	return fixture_id
