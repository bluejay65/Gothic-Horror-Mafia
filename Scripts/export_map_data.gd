tool
extends EditorScript

# CHECKS IF THE NODE HAS USE() METHOD TO DETERMINE IF IT'S A FIXTURE
func _run():
	print("Running")
	var map = get_scene()
	var fixture_dict: Dictionary = {}
	var fixture_file = File.new()
	if fixture_file.file_exists("res://Data/FixtureData.tres"):
		fixture_file.open("res://Data/FixtureData.tres", File.WRITE)
		
		for i in range(map.get_child_count()):
			if map.get_child(i).has_method("use"):
				var fixture = map.get_child(i)
				fixture_dict[fixture.name] = var2str(fixture.get_position())
		fixture_file.store_line(to_json(fixture_dict))
		fixture_file.close()
		print("JSON exported")
	else:
		print("No file at res://Data/FixtureData.tres")
			
