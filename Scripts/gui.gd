extends CanvasLayer

onready var slot_scene = preload("res://GUI/InventorySlot.tscn")
onready var player = get_node("..")
onready var map = get_node("../..")
onready var inventory_node = get_node("MarginContainer/InventoryContainer/Inventory")
var player_slots:Array = []
var selected_player_slot = null
var unselected_stylebox = null
var selected_stylebox = null


func _ready():
	for slot in range(player.max_inventory_size):
		var slot_instance = slot_scene.instance()
		var slot_panel = slot_instance.get_node("PanelContainer")
		player_slots.append(slot_instance)
		player.available_slots.append(slot_instance)
		
		inventory_node.add_child(slot_instance)
	
	unselected_stylebox = player_slots[0].get_node("PanelContainer").get_stylebox(Resources.ITEM_SLOT_STYLEBOX)
	selected_stylebox = unselected_stylebox.duplicate()
	selected_stylebox.set_border_width_all(3)
	selected_stylebox.set_border_color(Color(1, 1, 1, 1))
	
	selected_player_slot = player_slots[0]
	set_selected_player_slot(player_slots[0])

func set_selected_player_slot(slot):
	var last_slot_panel = selected_player_slot.get_node("PanelContainer")
	var slot_panel = slot.get_node("PanelContainer")
	selected_player_slot = slot
	
	last_slot_panel.add_stylebox_override(Resources.PANEL_CONTAINER_STYLEBOX, unselected_stylebox)
	slot_panel.add_stylebox_override(Resources.PANEL_CONTAINER_STYLEBOX, selected_stylebox)
	
func has_open_player_slot():
	return ItemInfo.has_open_slot(player_slots)

func first_open_player_slot():
	return ItemInfo.first_open_slot(player_slots)

func switch_inventory_slots(slot1, slot2):
	var id1 = slot1.item
	var id2 = slot2.item
	
	slot1.set_item(id2)
	slot2.set_item(id1)
