# a usable fixture that the player can sleep in

extends Fixture

func _ready():
	fixture_id = 1
	player_can_use = true

func use(player):
	Server.send_fixture_used(self)
	print(str(player)+": zzzzzzzzzzzz")
