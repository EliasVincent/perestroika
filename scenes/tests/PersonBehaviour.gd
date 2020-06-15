extends KinematicBody2D

onready var playerNode = get_node("/root/Main/Player")

var xSpeed = 0
var ySpeed = 0

var health = 100
var mad = false
var madStatus = 0
var madStatusDone = false
var chaseSpeed = 100
var followSpeed = 250
var agroRange = 80
var xDist = 0
var yDist = 0

enum State {IDLE, ATTACK, DEFEND}
var currentState = State.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	xDist = rand_range(-50, 50)
	yDist = rand_range(-50, 50)
	
func instanceInRange(instance, distance):
	#Check if instance is in range of given distance to player
	if instance.position.x > position.x - distance and instance.position.x < position.x + distance:
		if instance.position.y > position.y - distance and instance.position.y < position.y + distance:
			return true
	return false

func _process(delta):
	position += Vector2(xSpeed, ySpeed)
	
	#Mad Status
	var randNum = rand_range(0, 200000)
	if randNum < 1:
		mad = true
		
	if mad and not madStatusDone:
		madStatus += delta / 5;
		#Change Sprite Color
		$Sprite.modulate = Color(madStatus, 0, 0)
		
	if madStatus > 1:
		madStatusDone = true;
		madStatus = 1
		currentState = State.ATTACK
		
	#Change States with key
	if Input.is_action_just_pressed("idleState"):
		currentState = State.IDLE
	if (Input.is_action_just_pressed("attackState")):
		currentState = State.ATTACK
	
	match currentState:
		State.IDLE:
			xSpeed = rand_range(-1, 1)
			ySpeed = rand_range(-1, 1)
		State.ATTACK:	
			xSpeed = 0
			ySpeed = 0
			if instanceInRange(playerNode, agroRange):
				position = position.move_toward(playerNode.position, delta * chaseSpeed)
		State.DEFEND:
			xSpeed = 0
			ySpeed = 0
			$Sprite.modulate = Color(0, 0, 1)
			position = position.move_toward(playerNode.position + Vector2(xDist, yDist), delta * followSpeed)

	# looks if Person is mad and "inside" the player
	if mad and instanceInRange(playerNode, 1):
		PlayerData.Health -= 10
		queue_free()
