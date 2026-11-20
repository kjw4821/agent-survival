extends Control


func _ready() -> void:
	$Center/Content/Deploy.grab_focus()


func _deploy() -> void:
	get_tree().change_scene_to_file("res://combat/arena.tscn")


func _back_to_menu() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
