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
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool = upgrade_pool.filter(func (pool_upgrade): return pool_upgrade.id != upgrade.id)
			
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrade_pool.duplicate()
	for i in 2:
		if filtered_upgrades.size() == 0:
			# if there are no more upgrades to pick from
			break
		# pick a random upgrade from the remaining upgrades in our upgrade pool
		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(func (upgrade): return upgrade.id != chosen_upgrade.id)
	
	return chosen_upgrades

func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(current_level: int):
	# instantitiat upgrade screen
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
