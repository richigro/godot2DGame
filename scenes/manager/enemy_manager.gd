extends Node

# The current view port width of the game in units 
const VIEWPORT_WIDTH = 640
const BUFFER = 55
const SPAWN_RADIUS = (VIEWPORT_WIDTH / 2) + BUFFER

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()

func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	# Signal emmitted when the timer reaches 0
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

func get_spawn_position():
	# we want the enemy to spawn outside of the view of the player, but inside of the arena. 
	# The enemy will spawn in a random direction around the player's current position 
	# where SPAWN_RADIUS will determine how far the enemy will spawn from the player.
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var wall_collision_mask = 1	
	var spawn_position = Vector2.ZERO
	# a single unit vector that is randomly rotated anywhere from 0 radiants to 2pi radiants (or 0 to 360deg)
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	# we check 90deg increments until we find a valid spawn positon to spawn the enemy, thus the 4 times
	for i in 4:
		# a vector that points in a random direction with a magnitude of SPAWN_RADIUS
		var random_vector = random_direction * SPAWN_RADIUS
		# the position at the end of the random vector
		spawn_position = player.global_position + random_vector
		# raycast check to detect if there is a collision with a wall
		# from our player's current position to our new spawn positon
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, wall_collision_mask)
		var collision_result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if collision_result.is_empty():
			# this mean there are no collision detected, meaning our spawn position is within the arena
			break
		else:
			# here we know our current spawn position is outside of the arena
			# we rotate the current random direction by 90deg to see if we can find a spawn position
			# inside of the arena. we do this 4 times until we find a valid spawn position
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func on_timer_timeout():
	# re-start the timer
	timer.start()
	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	# add a new enemy scene to layer 
	entities_layer.add_child(enemy)
	# change the position of the spawned enemy
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	# the 12 comes from dividing the timer by the 
	var time_off = (0.1 / 12) * arena_difficulty
	# clamp time off
	time_off = min(time_off, 0.7)
	print(time_off)
	timer.wait_time = base_spawn_time - time_off
	
	# NOTE: the number can be change for testing purposes
	# after 6 seconds in the game have passed
	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 20)
