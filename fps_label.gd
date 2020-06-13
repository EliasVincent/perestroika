extends Label

func _process(delta):
	# FPS counter
	text = ""
	text +="fps: " + str(Engine.get_frames_per_second())
