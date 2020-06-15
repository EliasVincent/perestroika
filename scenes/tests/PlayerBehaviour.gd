extends KinematicBody2D

onready var enemiesFolder = get_node("/root/Main/Enemies")

var velocity = Vector2(0,0)
var hp = 100
const SPEED = 100
signal playerPosition
var numberOfEnters = 0

func getAllEnemiesInRadius(distance):
	#Get all child enemies
	var allEnemies = enemiesFolder.get_children()
	var selectedEnemies = []
	#Iterate through all enemies
	for i in allEnemies:
		#If true add to list of selected enemies
		if instanceInRange(i, distance):
			var enemy = [i]
			selectedEnemies += enemy
	return selectedEnemies
 
func instanceInRange(instance, distance):
	#Check if instance is in range of given distance to player
	if instance.position.x > position.x - distance and instance.position.x < position.x + distance:
		if instance.position.y > position.y - distance and instance.position.y < position.y + distance:
			return true
	return false

# everything physics and controls should happen in _physics_process
func _physics_process(delta):
	checkForEnemies()
	if Input.is_action_pressed("up"):
		velocity.y = -SPEED
	if Input.is_action_pressed("down"):
		velocity.y = SPEED
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
	
	#JOIN ABILITY
	if Input.is_action_just_pressed("action"):
		$RecruitAudioPlayer.play()
		var enemyList = getAllEnemiesInRadius(100)
		for i in enemyList:
			if i.currentState != i.State.DEFEND:
				var randNum = rand_range(0,9)
				if randNum < 3:
					i.currentState = i.State.DEFEND
				elif randNum < 4:
					i.mad = true
		
	# moves the body, with the velocity as parameter
	velocity = move_and_slide(velocity)

	# function that slowly stops the player, adjust the last value of the speed of the slowdown
	velocity.x = lerp(velocity.x,0,0.3)
	velocity.y = lerp(velocity.y,0,0.3)
	
	emit_signal("playerPosition")

func battle(enemyCount, enemyList):
	for i in enemyCount:
		var randNum = rand_range(0,2)
		if randNum < 1:
			#Delete defending unit
			for enemy in get_tree().get_nodes_in_group("enemy"):
				if enemy.currentState == enemy.State.DEFEND:
					enemy.queue_free()
					enemyCount-=1
					break
		else:
			#Delete enemy in range
			for enemy in enemyList:
				enemy.queue_free()
				enemyCount-=1
				break
		
func checkForEnemies():
	var enemyCount = 0
	var enemyList = []
	var defendUnitExists = false
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if instanceInRange(enemy, 50) and enemy.mad:
			enemyCount+=1
			var temp = [enemy]
			enemyList += temp
		if enemy.currentState == enemy.State.DEFEND:
			defendUnitExists = true
	if enemyCount > 0 and defendUnitExists:
		battle(enemyCount, enemyList)



