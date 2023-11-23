extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
# grab a reference to the experience manager node
@export var experience_manger: Node
@export var upgrade_screen_scene: PackedScene

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
	# instantitiat upgrade screen
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades([chosen_upgrade] as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
	
	
	
	
func apply_upgrade(upgrade: AbilityUpgrade):
	# check if we already have this upgrade
	var has_upgrade = current_upgrades.has(upgrade.id)
	# if we don't have the upgrade
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1,
		}
	else:
		# if we already have the upgrade increase the quantity
		# TODO: I might want to put a limit per ability.
		current_upgrades[upgrade.id]["quantity"] += 1
	print(current_upgrades)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
