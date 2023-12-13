extends Node

# This singleton emits a signal named experience vial collected, for
# other nodes to listen
signal experience_vial_collected(number: float)
# this signal is used to signal a new upgrade has been added
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged


func emit_experience_vial_collected(number: float):
	# emit our own custom signal
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	# emit custom signal
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_player_damaged():
	player_damaged.emit()
