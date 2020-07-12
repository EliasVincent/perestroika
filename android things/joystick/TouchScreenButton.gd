extends TouchScreenButton

var radius = Vector2(16, 16)
var boundary = 32

# we want the stick to follow when outside,
# but not activate when touching outside the stick first
# with -1 we can have multiple true states without making booleans for each
var ongoingDrag = -1

var returnAccel = 20

var threshold = 10

func _process(delta):
	if ongoingDrag == -1:
		var posDifference = (Vector2(0, 0) - radius) - position
		position += posDifference * returnAccel * delta

func get_button_position():
	return position + radius

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		
		# check if finger is in the joystick
		
		# = difference between it and parent node
		var event_distance_from_center = (event.position - get_parent().global_position).length()
		#print(event_distance_from_center)
		
		# get only .x because global_scale is Vector and boundary is not, would not be correct otherwise
		if event_distance_from_center <= boundary * global_scale.x or event.get_index() == ongoingDrag:
			# set button position to where finger is
			# and centers the position by subtracting the radius of the circleshape
			# * global_scale. so it's still in center no matter the scale of the joystick
			set_global_position(event.position - radius * global_scale)
		
		
			# func returns Vector2
			if get_button_position().length() > boundary:
				# normalized sets it to 1. Times boundary
				set_position(get_button_position().normalized() * boundary - radius)
			
			# get finger that's touching the stick
			ongoingDrag = event.get_index()
	
	# when finger let go, reset
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoingDrag:
		ongoingDrag = -1

func get_value():
	# threshold, has to be dragged at least x far to activate
	# and to compensate off-center touch and return animation
	if get_button_position().length() > threshold:
		# relative to parent node, the joystick
		# when movement is supposed to be analog (with diff speeds), then without normalized
		return get_button_position().normalized()
	else:
		return Vector2(0,0)

