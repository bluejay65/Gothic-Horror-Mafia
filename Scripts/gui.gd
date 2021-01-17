extends CanvasLayer

onready var slot_scene = preload("res://Scenes/InventorySlot.tscn")
onready var player = get_node("../Player")
onready var map = get_node("../..")
onready var inventory = get_node("MarginContainer/VBoxContainer/Inventory")


func _ready():
	for slot in range(player.max_inventory_size):
		var slot_instance = slot_scene.instance()
		slot_instance.set_name("Slot"+str(slot))
		inventory.add_child(slot_instance)

func item_picked_up(id):
	var slot = inventory.get_node("Slot"+str(player.inventory.size()-1))
	slot.get_node("PanelContainer/TextureRect").set_texture(ItemInfo.item_ids[id][ItemInfo.sprite])
