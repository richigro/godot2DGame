# This experience manager Node keeps track of the current experience 
# picked up by the player in the form of vials. The counter increments by one
# every time the player collides within the collision radius of the experience vial
extends Node

# creates a signal that can be emitted from this node 
# for other nodes to listen to
signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

# These are the global variables, and these values change as new vials are collected
# by the player
const TARGET_EXPERIENCE_GROWTH = 5

var current_experience = 0
var current_level = 1
var target_experience = 5

func _ready():
	# This node connects the the signal emitted by the GameEvents Node
	# everytime this GameEvents singleton send a new signal the on_experiece_vial_collected
	# function will run
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func increment_experience(number: float):
	# stop incrementing current_experience if we've reached the max number of points
	current_experience = min(current_experience + number, target_experience)
	# emmit the experience_updated signal
	experience_updated.emit(current_experience, target_experience)
	# Increment the level every time we reach the target experience or go past it
	if current_experience == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experience = 0
		# send current_experience and target_experience to listeners
		experience_updated.emit(current_experience, target_experience)
		# emit the signal for level up
		level_up.emit(current_level)


func on_experience_vial_collected(number: float):
	increment_experience(number)
