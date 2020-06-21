extends RichTextLabel

onready var playerNode = get_node("/root/Main/Player")

func _process(delta):
	text = ""
	text += "Q: RECRUIT (" + str(playerNode.JoinCost) + ")  " + "E: CHEER (" + str(playerNode.CheerCost) + ")"
