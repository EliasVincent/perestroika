tool
extends Control

export var nextScene: PackedScene
export var menuScene: PackedScene

func _on_RetryButton_pressed():
	# changes scene to our Main thing, can be changed to a main menu panel later
	get_tree().change_scene_to(nextScene)


func _on_MenuButton_pressed():
	get_tree().change_scene_to(menuScene)

func _process(delta):
	if Input.is_action_just_pressed("start_button"):
		get_tree().change_scene_to(nextScene)
