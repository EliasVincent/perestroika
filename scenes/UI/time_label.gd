extends Label

onready var countDownTimer = get_node("CountDownTimer")

signal playMusic

func _ready():
	countDownTimer.set_wait_time(100)
	countDownTimer.start()
	
func _process(delta):
	var timeLeft = countDownTimer.get_time_left()
	text = ""
	text += "TIME: " + str(stepify(timeLeft, 0.1))
	if timeLeft <= 20:
		modulate = Color(1,0,0,1)
