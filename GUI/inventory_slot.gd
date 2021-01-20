extends VBoxContainer

var item:int = -1
var is_locked:bool = false
var num_items:int = 0 #TODO make slots able to hold more than one item

signal item_added

func _ready():
	var panel_container = get_node("PanelContainer")
	panel_container.add_stylebox_override(Resources.PANEL_CONTAINER_STYLEBOX, panel_container.get_theme().get_stylebox(Resources.ITEM_SLOT_STYLEBOX, "PanelContainer"))

	panel_container.connect("mouse_entered", get_node(Resources.HUMAN_PATH), "_on_mouse_entered_slot", [self.get_node("PanelContainer")])
	panel_container.connect("mouse_exited", get_node(Resources.HUMAN_PATH), "_on_mouse_exited_slot", [self.get_node("PanelContainer")])


func has_item():
	if item > 0:
		return true
	return false
	
func is_item(id: int):
	return id == item

func set_item(id:int):
	get_node("PanelContainer/Sprite").set_z_index(0)
	if id > 0:
		item = id
		num_items = 1
		get_node("PanelContainer/Sprite").set_texture(ItemInfo.get_sprite(id))
		get_node("Label").set_text(ItemInfo.get_item_name(id))
		
		emit_signal("item_added")
	else:
		remove_item()
		

func set_item_num(id:int, num:int):
	get_node("PanelContainer/Sprite").set_z_index(0)
	if id > 0:
		item = id
		num_items = num
		get_node("PanelContainer/Sprite").set_texture(ItemInfo.get_sprite(id))
		get_node("Label").set_text(ItemInfo.get_item_name(id))
		
		emit_signal("item_added")
	else:
		item = -1
		num_items = 0
		get_node("PanelContainer/Sprite").set_texture(null)
		get_node("Label").set_text("")

func remove_item():
	item = -1
	num_items = 0
	get_node("PanelContainer/Sprite").set_texture(null)
	get_node("Label").set_text("")
	
func subtract_items(num):
	if num_items < num:
		return false
	if num_items == num:
		remove_item()
	else:
		num_items -= num

func add_items(num):
	num_items += num
