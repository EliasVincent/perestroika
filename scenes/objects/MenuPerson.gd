extends KinematicBody2D

var xSpeed = 0
var ySpeed = 0
var moveUpdate = 0.5

func updateMovewment():
	xSpeed = rand_range(-0.2, 0.2)
	ySpeed = rand_range(-0.2, 0.2)
	moveUpdate = rand_range(0.4,0.6)
