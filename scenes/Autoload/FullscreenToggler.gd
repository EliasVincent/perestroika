extends Node

func _process(delta):
	if Input.is_action_just_pressed("fullscreen_toggle"):
		# flips the value to true or false when pressed
		OS.window_fullscreen = !OS.window_fullscreen
