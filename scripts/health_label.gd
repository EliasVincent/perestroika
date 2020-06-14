extends Label

func _process(delta):
	# displays health
	text = ""
	text += "HEALTH: " # +str(Variable with the health, probably stored inside a Singleton)
# i.e. in Catformer it's +str(CatData.CoinCount)
