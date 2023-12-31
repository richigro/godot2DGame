extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

# A reference to the ability card scene
@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = $%CardContainer


func _ready():
	# This pauses everything in the game
	# This upgrade Screen will not get pause, because the process Mode 
	# in the inspector is set to Always meaning it can't be paused
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		# instantiate a new card
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		# play the in animation for card
		card_instance.play_in(delay)
		# by using the bind method we know which ability was selected or clicked on
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += 0.2


func on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	
	$AnimationPlayer.play("out")
	#wait for animation to finish before moving on to the next line of code
	await $AnimationPlayer.animation_finished
	# un-pause the game
	get_tree().paused = false
	# remove the upgrade screen once the upgrade has been selected
	queue_free()
