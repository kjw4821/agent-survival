extends Control


func _ready() -> void:
	$Center/Content/NewGame.grab_focus()


func _start_game() -> void:
	get_tree().change_scene_to_file("res://ui/briefing.tscn")


func _quit_game() -> void:
	get_tree().quit()
