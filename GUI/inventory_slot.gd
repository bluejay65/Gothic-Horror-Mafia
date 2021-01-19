extends VBoxContainer

var item:int = -1

func _ready():
	var panel_container = get_node("PanelContainer")
	panel_container.add_stylebox_override(Resources.PANEL_CONTAINER_STYLEBOX, panel_container.get_theme().get_stylebox(Resources.ITEM_SLOT_STYLEBOX, "PanelContainer"))

	panel_container.connect("mouse_entered", get_node(Resources.HUMAN_PATH), "_on_mouse_entered_slot", [self.get_node("PanelContainer")])
	panel_container.connect("mouse_exited", get_node(Resources.HUMAN_PATH), "_on_mouse_exited_slot", [self.get_node("PanelContainer")])


func has_item():
	if item > 0:
		return true
	return false

func set_item(id:int):
	get_node("PanelContainer/Sprite").set_z_index(0)
	if id > 0:
		item = id
		get_node("PanelContainer/Sprite").set_texture(ItemInfo.item_ids[id][ItemInfo.SPRITE])
		get_node("Label").set_text(ItemInfo.item_ids[id][ItemInfo.ITEM_NAME])
	else:
		item = -1
		get_node("PanelContainer/Sprite").set_texture(null)
		get_node("Label").set_text("")

func remove_item():
	item = -1
	get_node("PanelContainer/Sprite").set_texture(null)
	get_node("Label").set_text("")
