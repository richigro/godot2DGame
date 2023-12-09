extends Node

# defaults are set if not provided
@export var max_speed: int = 40
@export var acceleration: float = 5

var velocity = Vector2.ZERO


func accelerate_to_player():
	# grab the parent node where this function was called (it should be an enemy scene)
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	# vector substraction to get direction
	# the vector that you want to point towards goes first
	# we normalize to give the resultant vector a length of 1
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction)
	

func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	# This smoothing variable can be adjusted to get the right feeling
	var smoothing_value = get_process_delta_time() # seconds since the last process callback
	# linear interpolation explanation here: https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * smoothing_value))


func decelerate():
	accelerate_in_direction(Vector2.ZERO)


func move(character_body: CharacterBody2D):
	# assign our character's velocity to our internal velocity set in func above default is Vector2.ZERO
	character_body.velocity = velocity
	# tell generic character body to move and slide.
	# The move_and_slide method changes the velocity of the body after a collision
	character_body.move_and_slide()
	# we need to update the velocity after move_and_slide method has adjusted the internal velocity from a collision.
	velocity = character_body.velocity
