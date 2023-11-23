extends Node

# The current view port width of the game in units 
const VIEWPORT_WIDTH = 640
const BUFFER = 55
const SPAWN_RADIUS = (VIEWPORT_WIDTH / 2) + BUFFER

@export var basic_enemy_scene: PackedScene

func _ready():
	# Signal emmitted when the timer reaches 0
	$Timer.timeout.connect(on_timer_timeout)

# this function below will run every time the timer runs out
func on_timer_timeout():
	# spawn enemy outside the view of the player.
	# grab a reference to the player node
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	# we want the enemy to spawn outside of the view of the player. 
	# The enemy will spawn in a random direction around the player at the edge of a radius
	# relative to the player's current position
	# a single unit vector that is randomly rotated anywhere from 0 radiants to 2pi radiants (or 0 to 360deg)
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	# a vector that points in a random direction from 0 to 2pi radiants with a magnitude of SPAWN_RADIUS
	var random_vector = random_direction * SPAWN_RADIUS
	# Vector addition is used to translate the current postion of the player to the end of this random vector's head
	# in other words the tip the the random vector 
	var spawn_position = player.global_position + random_vector
	# instantiate a new enemy
	var enemy = basic_enemy_scene.instantiate() as Node2D
	# get the main scene
	var main_scene = get_parent()
	# add a new enemy at the main scene
	main_scene.add_child(enemy)
	# change the position of the spawned enemy to be our calculated spawn_position
	enemy.global_position = spawn_position
	

