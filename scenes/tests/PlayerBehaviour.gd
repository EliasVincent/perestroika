extends KinematicBody2D

onready var enemiesFolder = get_node("/root/Main/Enemies")
onready var camera = get_node("Camera2D")
onready var radCircle = get_node("RedCircle")

var velocity = Vector2(0,0)
var hp = 100
var currentRadius = 50
var SPEED = 100
var speedSave = SPEED
signal playerPosition
var numberOfEnters = 0
var currentDefenderCount = 0

var checkDefenderCountTimer = 5
var checkDefenderCountTimerSave = checkDefenderCountTimer

var JoinCost = 100
var CheerCost = 15
var joinCostSave = JoinCost
var cheerCostSave = CheerCost
var towerFameTimer = 1
var towerFameTimerSave = towerFameTimer

var cameraZoom = Vector2(0.75, 0.75)

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
		
	#Camera
	if cameraZoom > camera.get_zoom():
		camera.zoom += Vector2(delta / 4, delta / 4)
	if cameraZoom < camera.get_zoom():
		camera.zoom -= Vector2(delta / 4, delta / 4)
		
	checkDefenderCountTimer -= delta
	if checkDefenderCountTimer < 0:
		checkDefenderCountTimer = checkDefenderCountTimerSave
		countDefenders()
	
	#JOIN ABILITY
	if Input.is_action_just_pressed("join") and PlayerData.FAME >= JoinCost:
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
	if Input.is_action_just_pressed("cheer") and PlayerData.FAME >= CheerCost:
		PlayerData.FAME -= CheerCost
		$CheerAudioPlayer.play()
		var enemyList = getAllEnemiesInRadius(currentRadius)
		for i in enemyList:
			if i.currentState == i.State.DEFEND and i.mad:
					i.mad = false
					i.madStatus = 0
	
	# CHEATS, DELETE BEFORE RELEASE
	#if Input.is_action_just_pressed("fame-cheat"):
		#PlayerData.FAME += 300
	#if Input.is_action_just_pressed("death-cheat"):
		#PlayerData.Health = 0
	
	# moves the body, with the velocity as parameter
	velocity = move_and_slide(velocity)

	# function that slowly stops the player, adjust the last value of the speed of the slowdown
	velocity.x = lerp(velocity.x,0,0.3)
	velocity.y = lerp(velocity.y,0,0.3)
	
	#Check for towers
	for tower in get_tree().get_nodes_in_group("towers"):
		if position.distance_to(tower.position) < 75:
			if tower.maxFame > 0:
				towerFameTimer -= delta
				if towerFameTimer < 0:
					tower.get_node("CPUParticles2D").emitting = true
					PlayerData.FAME += 25
					tower.maxFame -= 25
					towerFameTimer = towerFameTimerSave
			else:
				tower.get_node("CPUParticles2D").emitting = false
		else:
			tower.get_node("CPUParticles2D").emitting = false
	
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
				cameraZoom = Vector2(0.75, 0.75)
				currentRadius = 100
				SPEED = speedSave
				JoinCost = joinCostSave
				CheerCost = cheerCostSave
				radCircle.scale.x = 1
				radCircle.scale.y = 1
				enemy.xDist = rand_range(-50, 50)
				enemy.yDist = rand_range(-50, 50)
	elif currentDefenderCount < 50:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.currentState == enemy.State.DEFEND or enemy.currentState == enemy.State.LOYALDEFEND:
				cameraZoom = Vector2(1, 1)
				currentRadius = 150
				SPEED = speedSave / 1.5
				JoinCost = joinCostSave * 1.5
				CheerCost = cheerCostSave * 1.5
				radCircle.scale.x = 3
				radCircle.scale.y = 3
				enemy.xDist = rand_range(-75, 75)
				enemy.yDist = rand_range(-75, 75)
	elif currentDefenderCount < 100:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.currentState == enemy.State.DEFEND or enemy.currentState == enemy.State.LOYALDEFEND:
				cameraZoom = Vector2(1.25, 1.25)
				currentRadius = 200
				SPEED = speedSave / 2
				JoinCost = joinCostSave * 2.5
				CheerCost = cheerCostSave * 2.5
				radCircle.scale.x = 6
				radCircle.scale.y = 6
				enemy.xDist = rand_range(-100, 100)
				enemy.yDist = rand_range(-100, 100)
	elif currentDefenderCount < 150:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.currentState == enemy.State.DEFEND or enemy.currentState == enemy.State.LOYALDEFEND:
				cameraZoom = Vector2(1.5, 1.5)
				currentRadius = 300
				SPEED = speedSave / 4
				JoinCost = joinCostSave * 4
				CheerCost = cheerCostSave * 4
				radCircle.scale.x = 12
				radCircle.scale.y = 12
				enemy.xDist = rand_range(-125, 125)
				enemy.yDist = rand_range(-125, 125)
	elif currentDefenderCount < 250:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.currentState == enemy.State.DEFEND or enemy.currentState == enemy.State.LOYALDEFEND:
				cameraZoom = Vector2(1.75, 1.75)
				currentRadius = 350
				SPEED = speedSave / 5
				JoinCost = joinCostSave * 6
				CheerCost = cheerCostSave * 6
				radCircle.scale.x = 18
				radCircle.scale.y = 18
				enemy.xDist = rand_range(-175, 175)
				enemy.yDist = rand_range(-175, 175)
	else:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.currentState == enemy.State.DEFEND or enemy.currentState == enemy.State.LOYALDEFEND:
				cameraZoom = Vector2(2, 2)
				currentRadius = 450
				SPEED = speedSave / 8
				JoinCost = joinCostSave * 10
				CheerCost = cheerCostSave * 10
				radCircle.scale.x = 24
				radCircle.scale.y = 24
				enemy.xDist = rand_range(-250, 250)
				enemy.yDist = rand_range(-250, 250)

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
