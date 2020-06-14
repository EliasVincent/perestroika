extends KinematicBody2D

onready var enemiesFolder = get_node("/root/Main/Enemies")

var velocity = Vector2(0,0)
const SPEED = 200
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
	
	if Input.is_action_pressed("up"):
		velocity.y = -SPEED
	if Input.is_action_pressed("down"):
		velocity.y = SPEED
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
	
	if Input.is_action_just_pressed("action"):
		var enemyList = getAllEnemiesInRadius(200)
		for i in enemyList:
			i.queue_free()
		
	# moves the body, with the velocity as parameter
	velocity = move_and_slide(velocity)

	# function that slowly stops the player, adjust the last value of the speed of the slowdown
	velocity.x = lerp(velocity.x,0,0.3)
	velocity.y = lerp(velocity.y,0,0.3)
	
	emit_signal("playerPosition")

func _ready():
	pass



