extends Node2D


var survival_time = 0.0

# Spawn settings
var starting_spawn_time = 2.0
var spawn_time = 2.0
var min_spawn_time = 0.4
var spawn_time_decrease = 0.8

# Round settings
var cycle_time = 0.0
var cycle_length = 30.0
var cycle_count = 1

# Mob difficulty
var mob_starting_health = 4
var mob_health_increase = 2

# Stats
var kill_count = 0

var xp = 0
var level = 1
var xp_needed = 5

var background_colors = [
	Color("#202040"),
	Color("#402020"),
	Color("#204020"),
	Color("#403020"),
	Color("#302040")
]

func _ready():
	%XPBar.min_value = 0
	%XPBar.max_value = xp_needed
	%XPBar.value = xp
	
	%LevelLabel.text = "Level %d" % level
	%RoundLabel.text = "%d" % cycle_count
	%LevelUpPanel.visible = false
	
	%Timer.wait_time = spawn_time
	


func change_background_color():
	var color_index = (cycle_count - 1) % background_colors.size()
	%BackgroundColor.color = background_colors[color_index]

func _process(delta):
	survival_time += delta
	cycle_time += delta
	
	var minutes = int(survival_time) / 60
	var seconds = int(survival_time) % 60
	
	%SurvivalTimer.text = "%02d:%02d" % [minutes, seconds]
	
	if cycle_time >= cycle_length:
		cycle_time -= cycle_length
		start_new_round()


func start_new_round():
	cycle_count += 1
	
	%RoundLabel.text = "%d" % cycle_count
	
	# Remove all currently living mobs
	for mob in get_tree().get_nodes_in_group("mobs"):
		mob.queue_free()
	
	# Make mobs spawn faster
	spawn_time = starting_spawn_time - ((cycle_count - 1) * spawn_time_decrease)
	spawn_time = max(spawn_time, min_spawn_time)
	
	%Timer.wait_time = spawn_time
	
	# Increase damage mobs deal when touching player
	$Player.increase_enemy_damage()
	
	# Change background color
	change_background_color()
	
	print("Round: ", cycle_count)
	print("Spawn time: ", spawn_time)


func add_xp(amount):
	xp += amount
	
	if xp >= xp_needed:
		level_up()
	else:
		update_xp_bar()


func update_xp_bar():
	%XPBar.max_value = xp_needed
	%XPBar.value = xp


func level_up():
	xp = 0
	
	level += 1
	xp_needed += 5

	%LevelLabel.text = "Level %d" % level
	
	update_xp_bar()
	
	%LevelUpPanel.visible = true
	
	get_tree().paused = true


func _on_damage_button_pressed():
	$Player.upgrade_damage()
	close_level_up()


func _on_fire_rate_button_pressed():
	$Player.upgrade_fire_rate()
	close_level_up()


func _on_health_button_pressed():
	$Player.upgrade_health()
	close_level_up()


func close_level_up():
	%LevelUpPanel.visible = false
	get_tree().paused = false


# -------------------------
# MOB SPAWNING
# -------------------------

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	
	new_mob.killed.connect(on_mob_killed)
	
	new_mob.add_to_group("mobs")
	
	# Increase mob health every round
	new_mob.health = mob_starting_health + ((cycle_count - 1) * mob_health_increase)
	
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	
	add_child(new_mob)


func on_mob_killed():
	kill_count += 1
	
	%KillCounter.text = "%d" % kill_count
	
	add_xp(1)


func _on_timer_timeout():
	spawn_mob()


func _on_player_health_depleted() -> void:
	var minutes = int(survival_time) / 60
	var seconds = int(survival_time) % 60
	
	%SurvivalTimer.visible = false
	%KillCounter.visible = false
	
	%TimeSurvived.text = "You Survived For: %02d:%02d" % [minutes, seconds]
	%MobsKilled.text = "Mobs Killed: %d" % kill_count
	
	%GameOver.visible = true
	get_tree().paused = true
