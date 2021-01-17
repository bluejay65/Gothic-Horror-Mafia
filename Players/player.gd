extends KinematicBody2D
class_name Player

var speed:int = 100
var entity_to_be_used = null
var usable_entities:Array = []
var inventory:Array = []
var max_inventory_size:int = 10
onready var area2d = get_node("Area2D")
onready var gui = get_node("../GUI")
onready var inventory_ui = gui.get_node("MarginContainer/VBoxContainer/Inventory")


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
	
	#use entities
	if Input.is_action_just_pressed("use"):
		if entity_to_be_used != null:
			entity_to_be_used.emit_signal("use", self)
	if Input.is_action_just_pressed("drop_item"): #drop items
		drop_item()

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

func pick_up(id):
	inventory.append(id)
	gui.item_picked_up(id)
	print(inventory)

func drop_item():
	if !inventory.empty(): #TODO make it drop the selected item in the inventory, not just the first item
		ItemInfo.spawn(inventory[0], get_position())
		inventory.remove(0)

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
