# gui controls the gui for the player's inventory

# Functions

# _ready():
# creates the slots in the player's inventory, sets the stylebox for selected slots, and sets the first slot to be selected

# set_selected_player_slot(slot):
# changes the selected_player_slot to the new slot, and changes the styleboxes for both the newly selected slot and the previously selected slot

# has_open_player_slot():
# checks if there is an empty slot in the player's inventory

# first_open_player_slot():
# returns the first empty slot in the player's inventory

# switch_inventory_slots(slot1, slot2):
#switches the items in two slots


extends CanvasLayer

onready var slot_scene = preload("res://GUI/InventorySlot.tscn") #scene for the slots that items go in
onready var player = get_node("..") #node for the player
onready var inventory_node = get_node("MarginContainer/InventoryContainer/Inventory") #node for the parent container of all the inventory slots
var player_slots:Array = [] #holds all the slots in the player's inventory
var selected_player_slot = null #the slot that the player holds and drops items from
var unselected_stylebox = null #the style for all the slots the player doesn't have selected
var selected_stylebox = null #the style for the one slot that the player has selected

# creates the slots in the player's inventory, sets the stylebox for selected slots, and sets the first slot to be selected
func setup_inventory():
	for slot in range(player.max_inventory_size):
		var slot_instance = slot_scene.instance()
		var slot_panel = slot_instance.get_node("PanelContainer")
		player_slots.append(slot_instance)
		player.available_slots.append(slot_instance)
		inventory_node.add_child(slot_instance)
		
	unselected_stylebox = player_slots[0].get_node("PanelContainer").get_stylebox(Resources.ITEM_SLOT_STYLEBOX) #sets the unselected stylebox to look like a default slot
	selected_stylebox = unselected_stylebox.duplicate() #sets the selected stylebox to look the same as the unselected stylebox
	selected_stylebox.set_border_width_all(3) #change the border width of the selected stylebox
	selected_stylebox.set_border_color(Color(1, 1, 1, 1)) #change the border color of the selected stylebox
	
	selected_player_slot = player_slots[0]
	set_selected_player_slot(player_slots[0])

# changes the selected_player_slot to the new slot, and changes the styleboxes for both the newly selected slot and the previously selected slot
func set_selected_player_slot(slot):
	var last_slot_panel = selected_player_slot.get_node("PanelContainer") #saves the panel of the previously selected slot
	var slot_panel = slot.get_node("PanelContainer") #sets the new slot's panel
	selected_player_slot = slot #changes which slot is selected
	
	last_slot_panel.add_stylebox_override(Resources.PANEL_CONTAINER_STYLEBOX, unselected_stylebox) #sets the stylebox of the unselected slot
	slot_panel.add_stylebox_override(Resources.PANEL_CONTAINER_STYLEBOX, selected_stylebox) #sets the stylebox of the selected slot

# checks if there is an empty slot in the player's inventory
func has_open_player_slot():
	return Helper.has_open_slot(player_slots)

# returns the first empty slot in the player's inventory
func first_open_player_slot():
	return Helper.first_open_slot(player_slots)

# switches the items in two slots
func switch_inventory_slots(slot1, slot2):
	if !(slot1.is_locked and slot2.has_item()) and !(slot1.has_item() and slot2.is_locked): #verifies that a locked slot isn't getting an item placed in it
		var item_id1 = slot1.item
		var item_id2 = slot2.item
		
		slot1.set_item(item_id2)
		slot2.set_item(item_id1)
