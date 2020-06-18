extends Label

onready var timer = get_node("Timer")

func _ready():
	timer.set_wait_time(3)
	timer.start()

func _on_Timer_timeout():
	PlayerData.FAMEPERSECOND = 0
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.currentState == enemy.State.DEFEND:
			PlayerData.FAMEPERSECOND += 1
		else:
			pass

func _process(delta):
	# displays fame currency and fame per tick
	text = ""
	text += "FAME: " + str(PlayerData.FAME) + "(+" + str(PlayerData.FAMEPERSECOND) + ")"
