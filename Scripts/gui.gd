extends CanvasLayer

onready var slot_scene = preload("res://Scenes/InventorySlot.tscn")
onready var player = get_node("../Player")
onready var map = get_node("../..")
onready var inventory = get_node("MarginContainer/VBoxContainer/Inventory")
var moused_slot = null
var unselected_stylebox = null
var selected_stylebox = null


func _ready():
	for slot in range(player.max_inventory_size):
		var slot_instance = slot_scene.instance()
		var slot_panel = slot_instance.get_node("PanelContainer")
		slot_instance.set_name("Slot"+str(slot))
		
		slot_panel.connect("mouse_entered", self, "_on_slot_mouse_enter", [slot_panel])
		slot_panel.connect("mouse_exited", self, "_on_slot_mouse_exit", [slot_panel])
		
		inventory.add_child(slot_instance)
	
	unselected_stylebox = inventory.get_node("Slot0/PanelContainer").get_stylebox("panel")
	selected_stylebox = unselected_stylebox.duplicate()
	selected_stylebox.set_border_width_all(3)
	selected_stylebox.set_border_color(Color(1, 1, 1, 1))
	
	slot_switched(0, 0)

func item_picked_up(id:int, slot_num:int):
	var slot = inventory.get_node("Slot"+str(slot_num))
	slot.get_node("PanelContainer/Sprite").set_texture(ItemInfo.item_ids[id][ItemInfo.sprite])
	slot.get_node("Label").set_text(ItemInfo.item_ids[id][ItemInfo.item_name])

func item_dropped(slot_num:int):
	var slot = inventory.get_node("Slot"+str(slot_num))
	slot.get_node("PanelContainer/Sprite").set_texture(null)
	slot.get_node("Label").set_text("")

func slot_switched(slot_num:int, last_slot_num:int):
	var last_slot_panel = inventory.get_node("Slot"+str(last_slot_num)+"/PanelContainer")
	var slot_panel = inventory.get_node("Slot"+str(slot_num)+"/PanelContainer")
	
	last_slot_panel.add_stylebox_override("panel", unselected_stylebox)
	slot_panel.add_stylebox_override("panel", selected_stylebox)

func _on_slot_mouse_enter(slot_panel):
	moused_slot = slot_panel.get_node("..")
	slot_panel.get_node("Sprite").get_material().set_shader_param("outline_color", Color(1, 1, 1, 1))

func _on_slot_mouse_exit(slot_panel):
	moused_slot = null
	slot_panel.get_node("Sprite").get_material().set_shader_param("outline_color", Color(0, 0, 0, 1))
