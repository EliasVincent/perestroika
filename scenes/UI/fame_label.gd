extends Label

func _process(delta):
	# displays fame currency
	text = ""
	text += "FAME: " + str(PlayerData.FAME)
