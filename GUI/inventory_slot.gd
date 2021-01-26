# inventory_slot controls each individual slot in every inventory

# _ready():
# sets the stylebox of the slot and connects the signals that emit when the mouse enters them TODO make the player not be the one that gets the signals

# has_item():
# returns whether or not the slot is empty

# is_item(item_id):
# returns whether or not the slot has a specific item

# set_item(item_id):
# sets the item in the slot

# set_item_num(item_id, num):
# sets the item in the slot, along with how many of that item there are

# remove_item():
# sets the slot to be empty

# subtract_items(num):
# subtracts num items from the amount of items in the slot

# add_items(num):
# adds num items to the amount of items in the slot


extends VBoxContainer

var item:int = -1 #the item_id of whatever's in the slot
var is_locked:bool = false #whether or not an item can be placed into the slot
var num_items:int = 0 #the number of items held in a slot TODO make slots able to hold more than one item

signal item_added

# sets the stylebox of the slot and connects the signals that emit when the mouse enters them TODO make the player not be the one that gets the signals
func _ready():
	var panel_container = get_node("PanelContainer")
	panel_container.add_stylebox_override(Resources.PANEL_CONTAINER_STYLEBOX, panel_container.get_theme().get_stylebox(Resources.ITEM_SLOT_STYLEBOX, "PanelContainer"))

	panel_container.connect("mouse_entered", get_node(Resources.HUMAN_PATH), "_on_mouse_entered_slot", [self.get_node("PanelContainer")])
	panel_container.connect("mouse_exited", get_node(Resources.HUMAN_PATH), "_on_mouse_exited_slot", [self.get_node("PanelContainer")])

# returns whether or not the slot is empty
func has_item():
	if item > 0:
		return true
	return false

# returns whether or not the slot has a specific item
func is_item(item_id: int):
	return item_id == item

# sets the item in the slot
func set_item(item_id:int):
	get_node("PanelContainer/Sprite").set_z_index(0) #sets the z index of the added sprite to the back
	if item_id > 0: #if an actual item is being placed in the slot
		item = item_id
		num_items = 1
		get_node("PanelContainer/Sprite").set_texture(ImportData.get_sprite(item_id)) #sets the sprite for the item in the slot
		get_node("Label").set_text(ImportData.get_item_name(item_id)) #sets the text for the item in the slot
		
		emit_signal("item_added")
	else:
		remove_item()

# sets the item in the slot, along with how many of that item there are
func set_item_num(item_id:int, num:int):
	get_node("PanelContainer/Sprite").set_z_index(0) #sets the z index of the added sprite to the back
	if item_id > 0: #if an actual item is being placed in the slot
		item = item_id
		num_items = num
		get_node("PanelContainer/Sprite").set_texture(ImportData.get_sprite(item_id)) #sets the sprite for the item in the slot
		get_node("Label").set_text(ImportData.get_item_name(item_id)) #sets the text for the item in the slot
		
		emit_signal("item_added")
	else:
		remove_item()

# sets the slot to be empty
func remove_item():
	item = -1
	num_items = 0
	get_node("PanelContainer/Sprite").set_texture(null)
	get_node("Label").set_text("")

# subtracts num items from the amount of items in the slot
func subtract_items(num):
	if num_items < num:
		return false
	if num_items == num:
		remove_item()
	else:
		num_items -= num

# adds num items to the amount of items in the slot
func add_items(num):
	num_items += num
