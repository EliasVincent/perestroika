extends RichTextLabel

onready var playerNode = get_node("/root/Main/Player")

func _process(delta):
	text = ""
	text += "(COST: " + str(playerNode.JoinCost) + ")  " + "            (COST: " + str(playerNode.CheerCost) + ")"
