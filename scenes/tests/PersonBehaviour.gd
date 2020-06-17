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
var target = null
var gettingTargeted = false

enum State {IDLE, ATTACK, DEFEND, JOIN, LEADER}
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
	var randNum = 0
	var randNum2 = 0
	#Mad Status
	if currentState == State.IDLE:
		randNum = rand_range(0, 100000)
	if currentState == State.DEFEND:
		randNum = rand_range(0, 7000)
	if randNum < 1:
		mad = true
	
	#Randomly join Player
	if currentState == State.IDLE:
		randNum2 = rand_range(0, 1000000)
	if randNum2 < 1 and not mad:
		currentState = State.DEFEND
		
	if mad and not madStatusDone:
		madStatus += delta / 5;
		#Change Sprite Color
		$Sprite.modulate = Color(1, 1, 1)
		$Sprite.modulate = Color(madStatus, 0, 0)
		
	if madStatus > 1:
		$TurnsEvilAudioPlayer.play()
		madStatusDone = true;
		madStatus = 1
		currentState = State.ATTACK

	#Search for enemy group
	if target == null and currentState == State.ATTACK and not gettingTargeted:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.currentState == enemy.State.ATTACK:
				if instanceInRange(enemy, 150):
					target = enemy
					target.gettingTargeted = true
					currentState = State.JOIN
					break
		
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
			if not mad:
				$Sprite.modulate = Color(0, 0, 1)
			position = position.move_toward(playerNode.position + Vector2(xDist, yDist), delta * followSpeed)
		State.JOIN:
			xSpeed = 0
			ySpeed = 0
			if target != null and is_instance_valid(target):
				position = position.move_toward(target.position + Vector2(xDist/2, yDist/2), delta * chaseSpeed)
				if instanceInRange(target, xDist/1.5):
					target = null
					currentState = State.ATTACK
			else:
				currentState = State.ATTACK



	# looks if Person is mad and "inside" the player
	if mad and instanceInRange(playerNode, 1):
		PlayerData.Health -= 10
		PlayerData.play_hit_by_enemy_audio()
		queue_free()


func person_death():
	$AnimationPlayer.play("PersonDeath")
