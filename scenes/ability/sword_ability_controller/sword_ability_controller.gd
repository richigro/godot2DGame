extends Node

const MAX_RANGE = 150

# instantiate a scene at runtime
@export var sword_ability: PackedScene
var base_damage = 5
var additional_damage_percent = 1
# this is the initial sword's rate
var base_wait_time

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	# the dollar sign is short for get node
	$Timer.timeout.connect(on_timer_timeout)
	# connect to a signal from the game events singleton
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var enemies = get_tree().get_nodes_in_group("enemy")
	# Get all enemies that are within 150 pixel radius from the player's current location
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
		
	# Sort enemies by the closeness to the player's current position. The closest will be first
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	# this can be instantiated because?
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	# Add the sword to the foreground layer
	foreground_layer.add_child(sword_instance)
	# assign a damage dealt
	sword_instance.hitbox_component.damage = base_damage * additional_damage_percent
	# place the sword at the position of the closest enemy within 150 pixels
	sword_instance.global_position = enemies[0].global_position
	# A Vector2.RIGHT has a rotation of 0
	# We then rotate that Vector2.RIGHT by a random amount between 0 and 2π. 
	# TAU is a constant value that represents 2π
	# Multiply by the offset, which is 4 pixels
	var offset = 4
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * offset
	# Calculate the direction vector from the start_vector (enemy's postion vector) to the end_vector (sword's position vector).
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	# rotate the sword toward the enemy's direction
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	# sword rate upgrade 
	if upgrade.id == "sword_rate":
		# we need to recalculate the timer's wait time
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
		# reduce the timer's wait time by the percent reduction & re-start the timer
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
	elif upgrade.id == "sword_damage":
		# TODO: I might want to upgrade a specified percent increase instead of hard-coding
		# 15 percent on every upgrade of this type
		additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * 0.15)
