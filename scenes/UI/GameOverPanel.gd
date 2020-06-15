tool
extends Control

export var nextScene: PackedScene

func _on_RetryButton_pressed():
	# changes scene to our Main thing, can be changed to a main menu panel later
	get_tree().change_scene_to(nextScene)
