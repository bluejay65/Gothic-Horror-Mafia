# a usable fixture that the player can sleep in

extends Fixture

func _ready():
	player_can_use = true

func _use(player):
	print(str(player)+": zzzzzzzzzzzz")
