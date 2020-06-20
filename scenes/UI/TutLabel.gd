extends Label

onready var tutTimer = get_node ("Timer")

func _ready():
	tutTimer.set_wait_time(60)
	tutTimer.start()

func _process(delta):
	var tutorialTime = tutTimer.get_time_left()
	text = ""
	text += str(stepify(tutorialTime, 0.1))
