extends CharacterBody2D


const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector = get_movement_vector()
	# Normalize input vector so that if we have a vector unit with 1 x and 1 y. The resultant is also always one an not square root of 2.
	var direction = movement_vector.normalized() # a vector with length of 1.
	# this comes from the 2d player class node. It is a property.
	var target_velocity = direction * MAX_SPEED
	# we want our character to accelerate smoothly
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)
