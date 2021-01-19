extends KinematicBody2D
class_name Player

var speed:int = 100
var entity_to_be_used = null
var fixture_opened = null
var usable_entities:Array = []

var available_slots:Array = []
var max_inventory_size:int = 10
var moused_slot = null
var mouse_held:bool = false
var moused_sprite = null


onready var area2d = get_node("Area2D")
onready var gui = get_node("GUI")


func _ready():
	area2d.connect("area_entered", self, "_on_Area2D_area_entered")
	area2d.connect("body_entered", self, "_on_Area2D_body_entered")
	area2d.connect("area_exited", self, "_on_Area2D_area_exited")
	area2d.connect("body_exited", self, "_on_Area2D_body_exited")

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
	
	if fixture_opened == null:
		#use entities
		if Input.is_action_just_pressed("use"):
			if entity_to_be_used != null:
				entity_to_be_used.use(self)
		if Input.is_action_just_pressed("drop_item"): #drop items
			drop_item()
	else:
		if Input.is_action_just_pressed("use"):
			fixture_opened.stop_use(self)
		
	#manage inventory
	change_inventory_slot()
	
	#mouse
	if Input.is_action_pressed("left_click"):
		if moused_slot != null:
			mouse_inventory()
		mouse_held = true
	if Input.is_action_just_released("left_click"):
		mouse_held = false
		after_mouse_inventory()

func _process(_delta):
	#determine which entity to use
	if !usable_entities.empty():
		if fixture_opened == null:
			var last_entity_to_be_used = entity_to_be_used
			entity_to_be_used = get_closest_entity(usable_entities)
			if entity_to_be_used != last_entity_to_be_used:
				entity_to_be_used.show_usable()
				if last_entity_to_be_used != null:
					last_entity_to_be_used.hide_usable()
	elif entity_to_be_used != null:
		entity_to_be_used.hide_usable()
		entity_to_be_used = null
	if fixture_opened != null and !usable_entities.has(fixture_opened): #TODO mkae the inventory slots determine whether or not the mouse is there themselves
		fixture_opened.stop_use(self)

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

func _on_mouse_entered_slot(slot):
	moused_slot = slot.get_parent()

func _on_mouse_exited_slot(slot):
	if moused_slot == slot.get_parent():
		moused_slot = null

func check_mouse_slot():
	var mouse_pos = get_viewport().get_mouse_position()
	
	for slot in available_slots:
		if slot.get_node("PanelContainer").get_global_rect().has_point(mouse_pos):
			moused_slot = slot
			break
		else:
			moused_slot = null

func change_inventory_slot():
	if Input.is_action_just_released("scroll_up"):
		var selected_player_slot_num = gui.player_slots.find(gui.selected_player_slot)
		if  selected_player_slot_num >= max_inventory_size-1:
			gui.set_selected_player_slot(gui.player_slots.front())
		else:
			gui.set_selected_player_slot(gui.player_slots[selected_player_slot_num+1])
	if Input.is_action_just_released("scroll_down"):
		var selected_player_slot_num = gui.player_slots.find(gui.selected_player_slot)
		if selected_player_slot_num <= 0:
			gui.set_selected_player_slot(gui.player_slots.back())
		else:
			gui.set_selected_player_slot(gui.player_slots[selected_player_slot_num-1])
	if Input.is_action_just_pressed("1"):
		if max_inventory_size >= 1:
			gui.set_selected_player_slot(gui.player_slots[0])

func pick_up(id):
	gui.first_open_player_slot().set_item(id)

func drop_item():
	if gui.selected_player_slot.has_item():
		ItemInfo.spawn(gui.selected_player_slot.item, get_position())
		gui.selected_player_slot.remove_item()

func mouse_inventory():
	if mouse_held == false: #only called when the mouse is clicked for the first time
		if gui.player_slots.has(moused_slot):
			gui.set_selected_player_slot(moused_slot)
		moused_sprite = moused_slot.get_node("PanelContainer/Sprite")
		moused_sprite.set_z_index(1)
		
	if mouse_held and moused_sprite != null: #called the entire time the mouse is held
		moused_sprite.follow_mouse()

func after_mouse_inventory():
	if moused_sprite != null:
		if moused_sprite.get_texture() != null:
			if moused_slot != null:
				var last_moused_slot = moused_slot
				check_mouse_slot()
				if moused_slot != null:
					if moused_slot != moused_sprite.get_node("../.."):
						var moused_slot_num = gui.player_slots.find(moused_slot)
						gui.switch_inventory_slots(moused_slot, last_moused_slot)
				else:
					drop_item()
					
		moused_sprite.set_z_index(0)
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
