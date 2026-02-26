extends Control

# PLAYER STATS

var max_health: int
var player_health: int = 20
var girl_exp: int = 0
#var girl_lv : int = 1
var next_exp: int = 1000
#var player_position:= Vector3.ZERO
@onready var hp_bar: ProgressBar = $SubViewportContainer/SubViewport/HPBar
@onready var health_label: Label = $SubViewportContainer/SubViewport/HPBar/health_label

@onready var level_tag: Label = $SubViewportContainer/SubViewport/PanelContainer/ExpBar/level
@onready var exp_progress: Label = $SubViewportContainer/SubViewport/PanelContainer/ExpBar/exp_progress


@onready var status_text: RichTextLabel = $SubViewportContainer/SubViewport/StatusBox/VBox/StatusText
@onready var line_edit: LineEdit = $SubViewportContainer/SubViewport/StatusBox/VBox/LineEdit

@onready var timer_label: Label = $SubViewportContainer/SubViewport/TimerLabel
@onready var d_label: Label = $SubViewportContainer/SubViewport/DLabel

var god_time : float = 0
#var dtime: float 

@onready var inventory: Node = $Inventory
@onready var enemies: Node = $Enemies

@onready var enemy_grid: GridContainer = $SubViewportContainer/SubViewport/EnemyTable/HBoxContainer/VBoxContainer/GridContainer
#@onready var grid_container: GridContainer = $SubViewportContainer/SubViewport/EnemyTable/HBoxContainer/VBoxContainer/GridContainer

@onready var ability_grid: GridContainer = $SubViewportContainer/SubViewport/AbilityContainer/MarginContainer/VBoxContainer/AbilityGrid
@onready var spawn_system: SpawnSystem = $spawn_system

# spawn conss?
const MAX_ENEMY_TABLE: int = 15

#var enemies_array : Array[EnemyNode] 
var active_threats_dict : Dictionary[String, EnemyNode] = {
	#"a1",
	#"a2",
	#"a3",
	#"a4",
	#"a5",
}

var upgrades_table : Dictionary = {}

var ability_dict : Dictionary[String, AbilityNode] = {}

var isViolence: bool = false

var QueryReply : Dictionary = {
	"/ping": "pong!",
	"/cum": "youve come! i always knew you would, but, you've come!\n You: I have... come.				",
	"/dance": "shiggy wiggy oogaa woooo..... hell yea",
	"/pee": "now you've gone and done it! *you piss your pants*",
	"use": "used "
}

func _ready() -> void:
	GameGlobals.GirlLevel = 1
	max_health = player_health
	status_text.text = ""
	
	line_edit.edit()
	
	call_deferred("get_abilities")
	call_deferred("get_entities")
	next_exp = next_level(GameGlobals.GirlLevel)
	update_player_health()
	update_player_level()
	update_player_experience()
	
	spawn_system.spawn_wave.connect(_add_enemies)


func _add_enemies(num_guys:int)->void:
	var enems := enemy_grid.get_children()
	var size_ec :int= enems.size()
	
	var guys_amt:int = size_ec
	
	
	
	
	
	for i in range(num_guys):
		if guys_amt >= 15: 
			print("full of guys! attempting replace!")
			for e in enems:
				if e.is_dead:
					e.reset(AssetsList.PARAMS_ENEMY_MOE)
					print("replaced ")
				else:
					print("welp")
			
			call_deferred("get_entities")
			return
		var enem := AssetsList.ENEMY_DATA.instantiate() as EnemyNode
		enem.params = AssetsList.PARAMS_ENEMY_MOE
		enemy_grid.add_child(enem)
		#guys_amt += 1
		print("number of guys: ", guys_amt)
	
	print("spawned ", num_guys)
	call_deferred("get_entities")


func get_entities()->void:
	var ec :Array[Node]= enemy_grid.get_children()
	
	var iter: int = 1
	var key: String = "a"
	for e in ec:
		if e is EnemyNode:
			var id := iter
			if iter > 15:
				print("nope! iter 15")
			elif iter > 10:
				key = "c"
				id %= 10
				#if id==0: id+=1
			elif iter > 5:
				key = "b" 
				id = (id % 6 ) + 1
				if id==0:
					id+=1
			else:
				key = "a"
			key+= str(id)
			active_threats_dict[key] = e
			if not e.deal_damage.is_connected(_on_take_damage):
				e.deal_damage.connect(_on_take_damage)
				e.died.connect(func()->void:
					#print("popped ", key)
					#active_threats_dict.erase(key)
					#active_threats_dict
					girl_exp += e.params.base_exp_yield
					call_deferred("check_the_dead")
					call_deferred("get_entities")
					call_deferred("update_player_experience")
					call_deferred("update_player_level")
				)
			iter += 1
			
			#print(active_threats_dict.find_key(e))
	print("enemy dictionary size: ", active_threats_dict.size())


func check_the_dead()->void:
	# what i want to happen.
	# when enemy dies, loop through enemy dict. if all are dead, add enemy
	var iter: int = 0
	for at in active_threats_dict:
		if active_threats_dict[at].is_dead:
			iter += 1
	
	
	if iter >= active_threats_dict.size():
		print("all dead. next wave")
		spawn_system.reset_wave_time()
		await get_tree().create_timer(1.0).timeout
		
		spawn_system.reset_wave_time()
		spawn_system.print_thingy()
		#if $spawn_system/SpawnTimer.wait_time > 1.0: 
			#$spawn_system/SpawnTimer.wait_time = 1.0
		#_add_enemies(1)


func _on_take_damage(dmg: int)->void:
	player_health -= dmg
	update_player_health()
	#idk play a sound, take damage

func update_player_health()->void:
	hp_bar.max_value = max_health
	
	if player_health <0: 
		player_health = 0
		# die
	
	hp_bar.value = player_health
	health_label.text = "HP %d/%d" % [player_health, max_health]
	
	if player_health == 0:
		get_tree().paused = true

func next_level(level: int)->int:
	var exponent:float = 2.1
	var base_exp: float = 10.0
	var result :int= floori(base_exp * (pow(level, exponent)))
	print("next level: ", result)
	return result #round((4 * (level^3))/ 5)

func update_player_experience()->void:
	exp_progress.text = "%d/%d" % [girl_exp, next_exp]
	
	if girl_exp >= next_exp:
		girl_level_up()

func update_player_level()->void:
	level_tag.text = "LV " + str(GameGlobals.GirlLevel)

func girl_level_up()->void:
	#girl_lv += 1
	GameGlobals.GirlLevel += 1
	var reset_exp :int=  girl_exp - next_exp
	
	girl_exp = 0 + reset_exp if reset_exp > 0 else 0
	next_exp = next_level(GameGlobals.GirlLevel)
	update_player_experience()


func get_abilities()->void:
	var ab :Array[Node]= ability_grid.get_children()
	var id: int = 1
	for i in ab:
		if i is AbilityNode:
			
			ability_dict[i.params.name.to_lower()] = i
			ability_dict[str(id)] = i
			id+=1
			
	
	print("ability dictionary size: ", ability_dict.size())



#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_cancel"):
		#line_edit.edit()

func _process(delta: float) -> void:
	god_time += delta
	var minutes :float= god_time / 60
	var seconds : float= fmod(god_time, 60)
	
	if not isViolence:
		GameGlobals.d_time += delta
	var dtime_display : float = fmod(GameGlobals.d_time, 60)
	
	#var stringtest: String = "23:" + "22"
	var minute_string : String = ""
	if minutes >= 1:
		minute_string = "%02d:" % minutes
		minute_string = minute_string.erase(0)
	if minutes >= 10:
		minute_string = "%02d:" % minutes
	#else:
		#minute_string = ""
	
	var second_string: String
	
	if seconds >= 10 or minutes >= 1:
		second_string = "%02d" % seconds
	else:
		second_string = "%01d" % seconds
	
	var time_string: String = "T:" + minute_string + second_string
	
	var dtime_string: String = "D%3d" % dtime_display 
	#time_string = time_string.replace("0", "")
	
	timer_label.text = time_string
	d_label.text = dtime_string
	#update


func add_line_to_status(line: String)->void:
	status_text.text += "\n" + line

# commands: USE <MOVENAMEE> (can omit use?)
# CHECK <MOVENAMEE> 
# ITEMS

func use_ability(ability: AbilityNode, enemy: EnemyNode)->void:
	if enemy.is_dead: return
	if ability.params.type == ability.params.HitType.SINGLE:
		if !enemy:
			print("specify coord")
		else:
			enemy.take_damage(ability.params.power)
	
	ability.timer.start()

func _on_line_submission(new_query: String) -> void:
	var query :String = new_query.to_lower()
	add_line_to_status(">>" + query)
	var unrecognized : String = "Unrecognized Query"
	
	var comm_arr :PackedStringArray= query.split(" ", true, 3)
	
	#print("args array splits ", comm_arr.size())
	
	
	
	var reply :Variant= QueryReply.get(comm_arr[0], unrecognized)
	#if reply:
	#print(comm_arr.size())
	if comm_arr.size() == 2 and ability_dict.has(comm_arr[0]) and active_threats_dict.has(comm_arr[1]):
		#@TODO assume ability is being used?
		print("2 args pass")
		if not active_threats_dict.get(comm_arr[1]).is_dead:
			var ability :AbilityNode= ability_dict.get(comm_arr[0])
			var enemy :EnemyNode= active_threats_dict.get(comm_arr[1])
			if ability.timer.is_stopped():
				use_ability(ability, enemy)
				if not active_threats_dict.get(comm_arr[1]).is_dead:
					reply = "used %s on %s (%s)" % [ability.params.name, enemy.params.name, active_threats_dict.find_key(enemy)]
				else:
					reply = "destroyed %s with %s" % [enemy.params.name, ability.params.name]
			else:
				reply = "ability on cooldown"
		else:
			reply = "nothing there."
		#pass
	elif reply == "used ":
		if comm_arr.size() == 3 and ability_dict.has(comm_arr[1]) and active_threats_dict.has(comm_arr[2]):
			if not active_threats_dict.get(comm_arr[2]).is_dead:
				var ability :AbilityNode= ability_dict.get(comm_arr[1])
				var enemy :EnemyNode= active_threats_dict.get(comm_arr[2])
				if ability.timer.is_stopped():
					use_ability(ability, enemy)
					reply = "used %s on %s (%s)" % [ability.params.name, enemy.params.name, active_threats_dict.find_key(enemy)]
				else:
					reply = "ability on cooldown"
			else:
				reply = "nothing there."
			
		elif comm_arr.size() == 1:
			reply = "usage: USE <ability> <coord>\ncoords are a1 - c5 "
		else:
			reply = "ability not recognized."
	#else:
	add_line_to_status(reply)
	
	line_edit.text = ""


func _on_line_edit_editing_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		line_edit.edit()


func do_effect(effect: EffectItem)->void:
	#TODO pass effect, do damage rules, effect.activate()
	effect.activate()
	pass
