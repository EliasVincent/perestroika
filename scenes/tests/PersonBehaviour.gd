extends KinematicBody2D

onready var playerNode = get_node("/root/Main/Player")

var xSpeed = 0
var ySpeed = 0
var moveUpdate = 0.5

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

enum State {IDLE, ATTACK, DEFEND, JOIN, LEADER, LOYAL, LOYALDEFEND, DYING}
var currentState = State.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	xDist = rand_range(-50, 50)
	yDist = rand_range(-50, 50)
	
	var randNum = rand_range(0, 75)
	if randNum < 1:
		currentState = State.LOYAL
	
func instanceInRange(instance, distance):
	#Check if instance is in range of given distance to player
	if instance.position.x > position.x - distance and instance.position.x < position.x + distance:
		if instance.position.y > position.y - distance and instance.position.y < position.y + distance:
			return true
	return false
	
func updateMovewment():
	xSpeed = rand_range(-0.2, 0.2)
	ySpeed = rand_range(-0.2, 0.2)
	moveUpdate = rand_range(0.4,0.6)

func _process(delta):
	position += Vector2(xSpeed, ySpeed)
	
	var randNum = 2
	var randNum2 = 2
	#Mad Status
	if currentState == State.IDLE:
		randNum = rand_range(0, 50000)
	if currentState == State.DEFEND:
		randNum = rand_range(0, 3000)
	if randNum < 1:
		mad = true
	
	#Randomly join Player
	if currentState == State.IDLE:
		randNum2 = rand_range(0, 200000)
	if randNum2 < 1 and not mad:
		currentState = State.DEFEND
		
	if mad and not madStatusDone:
		madStatus += delta / 5;
		#Change Sprite Color
		$AnimatedSprite.modulate = Color(1, 1, 1, 1)
		$AnimatedSprite.modulate = Color(madStatus, 0, 0, 1)
		
	if madStatus > 1:
		if currentState == State.DEFEND:
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
			moveUpdate -= delta
			if (moveUpdate < 0):
				updateMovewment()
		State.ATTACK:	
			xSpeed = 0
			ySpeed = 0
			if instanceInRange(playerNode, agroRange):
				position = position.move_toward(playerNode.position, delta * chaseSpeed)
		State.DEFEND:
			xSpeed = 0
			ySpeed = 0
			if not mad:
				$AnimatedSprite.modulate = Color(0, 0, 1, 1)
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
		State.LOYAL:
			moveUpdate -= delta
			if (moveUpdate < 0):
				updateMovewment()
			$AnimatedSprite.modulate = Color(1, 1, 0.1, 1)
		State.LOYALDEFEND:
			xSpeed = 0
			ySpeed = 0
			$AnimatedSprite.modulate = Color(1, 1, 0.1, 1)
			position = position.move_toward(playerNode.position + Vector2(xDist, yDist), delta * followSpeed)
		State.DYING:
			pass

	# looks if Person is mad and "inside" the player
	if mad and instanceInRange(playerNode, 1):
		if not currentState == State.DYING:
			PlayerData.Health -= 10
			PlayerData.play_hit_by_enemy_audio()
			currentState = State.DYING
			person_death()


func person_death():
	$AnimationPlayer.play("PersonDeath")

func defender_death():
	$AnimationPlayer.play("DefenderDeath")
