extends KinematicBody2D

onready var enemiesFolder = get_node("/root/Main/Enemies")
onready var camera = get_node("Camera2D")

var velocity = Vector2(0,0)
var hp = 100
var currentRadius = 100
const SPEED = 100
signal playerPosition
var numberOfEnters = 0
var currentDefenderCount = 0

var checkDefenderCountTimer = 5
var checkDefenderCountTimerSave = checkDefenderCountTimer

var JoinCost = 100
var CheerCost = 40

onready var timer = get_node("Timer")

func _ready():
	timer.set_wait_time(3)
	timer.start()
	$AnimatedSprite.modulate = Color(0.1, 1, 0.2, 1)

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
		
	checkDefenderCountTimer -= delta
	if checkDefenderCountTimer < 0:
		checkDefenderCountTimer = checkDefenderCountTimerSave
		countDefenders()
	
	#JOIN ABILITY
	if Input.is_action_just_pressed("join") and PlayerData.FAME > 99:
		PlayerData.FAME -= JoinCost
		$RecruitAudioPlayer.play()
		var enemyList = getAllEnemiesInRadius(currentRadius)
		for i in enemyList:
			if i.currentState == i.State.LOYAL:
				i.currentState = i.State.LOYALDEFEND
			elif i.currentState != i.State.DEFEND and not i.mad:
				var randNum = rand_range(0,9)
				if randNum < 3:
					i.currentState = i.State.DEFEND
				elif randNum < 4:
					i.mad = true
					
	#CHEER ABILITY
	if Input.is_action_just_pressed("cheer") and PlayerData.FAME > 39:
		PlayerData.FAME -= CheerCost
		var enemyList = getAllEnemiesInRadius(currentRadius)
		for i in enemyList:
			if i.currentState == i.State.DEFEND and i.mad:
					i.mad = false
					i.madStatus = 0
	
	# CHEATS, DELETE BEFORE RELEASE
	if Input.is_action_just_pressed("fame-cheat"):
		PlayerData.FAME += 300
	if Input.is_action_just_pressed("death-cheat"):
		PlayerData.Health = 0
	
	# moves the body, with the velocity as parameter
	velocity = move_and_slide(velocity)

	# function that slowly stops the player, adjust the last value of the speed of the slowdown
	velocity.x = lerp(velocity.x,0,0.3)
	velocity.y = lerp(velocity.y,0,0.3)
	
	emit_signal("playerPosition")

#Count Defenders
func countDefenders():
	currentDefenderCount = 0
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.currentState == enemy.State.DEFEND or enemy.currentState == enemy.State.LOYALDEFEND:
			currentDefenderCount += 1
			
	if currentDefenderCount < 20:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.currentState == enemy.State.DEFEND or enemy.currentState == enemy.State.LOYALDEFEND:
				camera.zoom = Vector2(0.75, 0.75)
				enemy.xDist = rand_range(-50, 50)
				enemy.yDist = rand_range(-50, 50)
	elif currentDefenderCount < 40:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.currentState == enemy.State.DEFEND or enemy.currentState == enemy.State.LOYALDEFEND:
				camera.zoom = Vector2(1, 1)
				enemy.xDist = rand_range(-75, 75)
				enemy.yDist = rand_range(-75, 75)
	elif currentDefenderCount < 60:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.currentState == enemy.State.DEFEND or enemy.currentState == enemy.State.LOYALDEFEND:
				camera.zoom = Vector2(1.25, 1.25)
				enemy.xDist = rand_range(-100, 100)
				enemy.yDist = rand_range(-100, 100)
	else:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.currentState == enemy.State.DEFEND or enemy.currentState == enemy.State.LOYALDEFEND:
				camera.zoom = Vector2(1.5, 1.5)
				enemy.xDist = rand_range(-125, 125)
				enemy.yDist = rand_range(-125, 125)

func battle(enemyCount, enemyList):
	for i in enemyCount:
		var randNum = rand_range(0,2)
		if randNum < 1:
			#Delete defending unit
			for enemy in get_tree().get_nodes_in_group("enemy"):
				if enemy.currentState == enemy.State.DEFEND:
					enemy.currentState = enemy.State.DYING
					enemy.defender_death()
					enemyCount-=1
					break
				elif enemy.currentState == enemy.State.LOYALDEFEND:
					enemy.queue_free()
					enemyCount-=1
					break
		else:
			#Delete enemy in range
			for enemy in enemyList:
				enemy.currentState = enemy.State.DYING
				enemy.person_death()
				enemyCount-=1
				break
		
func checkForEnemies():
	var enemyCount = 0
	var enemyList = []
	var defendUnitExists = false
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if instanceInRange(enemy, 50) and enemy.currentState == enemy.State.ATTACK:
			enemyCount+=1
			var temp = [enemy]
			enemyList += temp
		if enemy.currentState == enemy.State.DEFEND:
			defendUnitExists = true
	if enemyCount > 0 and defendUnitExists:
		battle(enemyCount, enemyList)

func _on_Main_hasDied():
	$PlayerDeathParticles.emitting = true


func _on_Timer_timeout():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.currentState == enemy.State.DEFEND:
			PlayerData.FAME += 1
		else:
			pass
