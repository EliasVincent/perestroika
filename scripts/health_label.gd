extends Label

onready var playerNode = get_node("/root/Main/Player")

func _process(delta):
	# displays health
	text = ""
	text += "HEALTH: " + str(PlayerData.Health)# +str(Variable with the health, probably stored inside a Singleton)
# i.e. in Catformer it's +str(CatData.CoinCount)
