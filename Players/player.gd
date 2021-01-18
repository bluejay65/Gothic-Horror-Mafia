extends KinematicBody2D
class_name Player

var speed:int = 100
var entity_to_be_used = null
var usable_entities:Array = []
var inventory:Array = []
var max_inventory_size:int = 10
var selected_slot:int = 0
var mouse_held:bool = false
var moused_sprite = null
onready var area2d = get_node("Area2D")
onready var gui = get_node("../GUI")
onready var inventory_ui = gui.get_node("MarginContainer/VBoxContainer/Inventory")


func _ready():
	area2d.connect("area_entered", self, "_on_Area2D_area_entered")
	area2d.connect("body_entered", self, "_on_Area2D_body_entered")
	area2d.connect("area_exited", self, "_on_Area2D_area_exited")
	area2d.connect("body_exited", self, "_on_Area2D_body_exited")
	
	for _i in range(max_inventory_size):
		inventory.append(0)

func _physics_process(_delta):
	#movement
	var movement = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		movement += Vector2.UP
	if Input.is_action_pressed("down"):
		movement += Vector2.DOWN
	if Input.is_action_pressed("left"):
		movement += Vector2.LEFT
	if Input.is_action_pressed("right"):
		movement += Vector2.RIGHT
		
	move_and_slide(movement.normalized()*speed)
	
	#use entities
	if Input.is_action_just_pressed("use"):
		if entity_to_be_used != null:
			entity_to_be_used.emit_signal("use", self)
	if Input.is_action_just_pressed("drop_item"): #drop items
		drop_item()
		
	#manage inventory
	change_inventory_slot()
	
	#mouse
	if Input.is_action_pressed("left_click"):
		if gui.moused_slot != null:
			mouse_inventory()
		mouse_held = true
	if Input.is_action_just_released("left_click"):
		mouse_held = false
		after_mouse_inventory()

func _process(_delta):
	#determine which entity to use
	if !usable_entities.empty():
		var last_entity_to_be_used = entity_to_be_used
		entity_to_be_used = get_closest_entity(usable_entities)
		
		if entity_to_be_used != last_entity_to_be_used:
			entity_to_be_used.emit_signal("show_usable")
			if last_entity_to_be_used != null: #TODO use get_class when that is fixed
				last_entity_to_be_used.emit_signal("hide_usable")
	elif entity_to_be_used != null:
		entity_to_be_used.emit_signal("hide_usable")
		entity_to_be_used = null

func _on_Area2D_body_entered(body):
	if body.is_in_group("entities"):
		usable_entities.append(body)

func _on_Area2D_body_exited(body):
	if body.is_in_group("entities"):
		usable_entities.erase(body)

func _on_Area2D_area_entered(area):
	if area.is_in_group("entities"):
		usable_entities.append(area)

func _on_Area2D_area_exited(area):
	if area.is_in_group("entities"):
		usable_entities.erase(area)

func change_inventory_slot():
	var last_selected_slot = selected_slot
	if Input.is_action_just_released("scroll_up"):
		if selected_slot <= 0:
			selected_slot = max_inventory_size-1
		else:
			selected_slot -= 1
		gui.slot_switched(selected_slot, last_selected_slot)
	if Input.is_action_just_released("scroll_down"):
		if selected_slot >= max_inventory_size-1:
			selected_slot = 0
		else:
			selected_slot += 1
		gui.slot_switched(selected_slot, last_selected_slot)
	if Input.is_action_just_pressed("1"):
		if max_inventory_size > 0:
			selected_slot = 0
			gui.slot_switched(selected_slot, last_selected_slot)
	if Input.is_action_just_pressed("2"):
		if max_inventory_size > 1:
			selected_slot = 1
			gui.slot_switched(selected_slot, last_selected_slot)
	if Input.is_action_just_pressed("3"):
		if max_inventory_size > 2:
			selected_slot = 2
			gui.slot_switched(selected_slot, last_selected_slot)
	if Input.is_action_just_pressed("4"):
		if max_inventory_size > 3:
			selected_slot = 3
			gui.slot_switched(selected_slot, last_selected_slot)
	if Input.is_action_just_pressed("5"):
		if max_inventory_size > 4:
			selected_slot = 4
			gui.slot_switched(selected_slot, last_selected_slot)
	if Input.is_action_just_pressed("6"):
		if max_inventory_size > 5:
			selected_slot = 5
			gui.slot_switched(selected_slot, last_selected_slot)
	if Input.is_action_just_pressed("7"):
		if max_inventory_size > 6:
			selected_slot = 6
			gui.slot_switched(selected_slot, last_selected_slot)
	if Input.is_action_just_pressed("8"):
		if max_inventory_size > 7:
			selected_slot = 7
			gui.slot_switched(selected_slot, last_selected_slot)
	if Input.is_action_just_pressed("9"):
		if max_inventory_size > 8:
			selected_slot = 8
			gui.slot_switched(selected_slot, last_selected_slot)
	if Input.is_action_just_pressed("0"):
		if max_inventory_size > 9:
			selected_slot = 9
			gui.slot_switched(selected_slot, last_selected_slot)

func set_inventory_slot(slot_num):
	var last_selected_slot = selected_slot
	selected_slot = slot_num
	gui.slot_switched(selected_slot, last_selected_slot)

func pick_up(id):
	var slot_num = inventory.find(0)
	inventory[slot_num] = id
	gui.item_picked_up(id, slot_num)
	print(inventory)

func drop_item():
	if inventory[selected_slot] > 0: #TODO make it drop the selected item in the inventory, not just the first item
		ItemInfo.spawn(inventory[selected_slot], get_position())
		gui.item_dropped(selected_slot)
		inventory[selected_slot] = 0

func mouse_inventory():
	if mouse_held == false: #only called when the mouse is clicked for the first time
		set_inventory_slot(int(gui.moused_slot.name.substr(3)))
		moused_sprite = gui.moused_slot.get_node("PanelContainer/Sprite")
		moused_sprite.get_material().set_shader_param("opacity", 0.75)
		
	if mouse_held and moused_sprite != null: #called the entire time the mouse is held
		moused_sprite.go_to(get_global_mouse_position())

func after_mouse_inventory():
	if moused_sprite != null:
		moused_sprite.get_material().set_shader_param("opacity", 1)
		moused_sprite.reset_position()

# helper functions
func get_closest_entity(arr:Array): #TODO make the closest_entity always be above another if they're at the same position
	var player_pos = self.get_position()
	var closest_distance_sqr = INF
	var closest_entity = null
	
	for entity in arr:
		var dist_to_entity = player_pos.distance_squared_to(entity.position)
		if dist_to_entity <= closest_distance_sqr:
			closest_distance_sqr = dist_to_entity
			closest_entity = entity
	return closest_entity
