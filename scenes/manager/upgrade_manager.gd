extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
# grab a reference to the experience manager node
@export var experience_manger: Node

# will be used to store all the upgrades we've obtained so far
var current_upgrades = {}

# connect to the level up signal emitted by the experience manager node
func _ready():
	experience_manger.level_up.connect(on_level_up)
	

func on_level_up(current_level: int):
	# when the player levels up we want to assign a new ability
	# pick a random upgrade from the upgrade pool
	var chosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade
	if chosen_upgrade == null:
		return
		
	# check if we already have this upgrade
	var has_upgrade = current_upgrades.has(chosen_upgrade.id)
	# if we don't have the upgrade
	if !has_upgrade:
		current_upgrades[chosen_upgrade.id] = {
			"resource": chosen_upgrade,
			"quantity": 1,
		}
	else:
		# if we already have the upgrade increase the quantity
		# TODO: I might want to put a limit per ability.
		current_upgrades[chosen_upgrade.id]["quantity"] += 1
