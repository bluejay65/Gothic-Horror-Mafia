extends Sprite


func _ready():
	connect("texture_changed", self, "on_texture_changed")

func on_texture_changed():
	if get_texture() != null:
		var panel = get_node("..")
		var panel_border_width = panel.get_stylebox("panel").get_border_width(0)
		var panel_size = Vector2(panel.get_size().x - panel_border_width*2, panel.get_size().y - panel_border_width*2)
		var sprite_size = get_rect().size
	
		set_position(Vector2(panel_size.x/2 + panel_border_width, panel_size.y/2 + panel_border_width))
	
		if get_texture().get_height() > get_texture().get_width():
			var new_scale = panel_size.y/sprite_size.y
			set_scale(Vector2(new_scale, new_scale))
		else:
			var new_scale = panel_size.x/sprite_size.x
			set_scale(Vector2(new_scale, new_scale))

func reset_position():
	var panel = get_node("..")
	var panel_border_width = panel.get_stylebox("panel").get_border_width(0)
	var panel_size = Vector2(panel.get_size().x - panel_border_width*2, panel.get_size().y - panel_border_width*2)
	
	set_position(Vector2(panel_size.x/2 + panel_border_width, panel_size.y/2 + panel_border_width))

func go_to(pos):
	set_position(get_position() + to_local(get_global_mouse_position()))
	#print(get_position())
