extends CharacterBody3D



@export var dashCurve : Curve

@export var camera: Camera3D


# should face the cursor
@onready var attack_pivot: Node3D = $attack_pivot

# attack point
@onready var attack_point: Marker3D = $attack_pivot/attack_point

# TIMERS
@onready var step_cooldown: Timer = $stepCooldown
@onready var step_time: Timer = $stepTime
@onready var atk_cooldown: Timer = $atk_cooldown

#@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer2D
@onready var sfx_player: AudioStreamPlayer2D = $Node/SFXPlayer2D

const SPEED = 12.0
const STEP_SPEED = 68.0
const JUMP_VELOCITY = 4.5

const RAYCAST_LEN : float = 10000

#dont feel like using them yet
enum MoveStates {IDLE, MOVING, DASH}
enum AttackStates {ATTACK, GRAPPLE, SLINGSHOT}

var canAttack: bool = true
var canDash: bool = true

var isDashing: bool = false

var input_dir : Vector2

var last_result : Vector3


#@onready var cursortest: MeshInstance3D = $cursortest

func _ready() -> void:
	step_cooldown.timeout.connect(on_steptimer_timeout)
	atk_cooldown.timeout.connect(_on_atk_timeout)
	
	#cursortest.reparent(get_parent())

func _input(event: InputEvent) -> void:
	
	
	
	
	if Input.is_action_pressed("slash"):
		
		do_attack()
	
	if Input.is_action_just_pressed("grapple"):
		print("do grapple!")
		SoundPlayer.play_sound2(AssetsList.ATTACK2)
	
	
	if Input.is_action_just_pressed("bigstep"):
		if canDash:
			isDashing = true
		

#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#GameGlobals.cursor_pos_viewport = event.position


func _process(delta: float) -> void:
	GameGlobals.cursor_pos_viewport = get_viewport().get_mouse_position()
	#pass

func _physics_process(delta: float) -> void:
	# raycast
	var space_state = get_world_3d().direct_space_state
	var from: = camera.project_ray_origin(GameGlobals.cursor_pos_viewport)
	var to := from + camera.project_ray_normal(GameGlobals.cursor_pos_viewport) * RAYCAST_LEN
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	
	if result:
		#print("YEAHHHH")
		GameGlobals.cursor_pos_3d = result.position
	
	#cursortest.
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP, deg_to_rad(45))
	
	if isDashing:
		do_big_step(direction)
		return
	
	input_dir = Input.get_vector("move_a", "move_d", "move_w", "move_s")
	#var direction := (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		#print(velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func do_attack()->void:
	if !canAttack: return
	
	attack_pivot.look_at(GameGlobals.cursor_pos_3d)
	
	var atk = AssetsList.PLAYER_ATK.instantiate()
	add_child(atk)
	atk.global_position = attack_point.global_position
	
	#print("do attack!!!")
	SoundPlayer.play_sound2(AssetsList.ATTACK1)
	
	canAttack = false
	atk_cooldown.start()

func do_big_step(direction: Vector3)->void:
	#if !canDash: return
	# ============== DASHING LOGIC ==============
	
	if !direction:
		#print("no direction")
		direction = (GameGlobals.cursor_pos_3d - global_position).normalized()
		#return
	
	canDash = false
	
	
	
	if step_time.is_stopped():
		var sfx_step :AudioStreamPlayer= SoundPlayer.play_sound(AssetsList.SFX_DASH)
		
		
		#sfx_step..connect(func()->void: )
		
		#if !step_time.timeout.has_connections():
		#step_time.timeout.connect(func()->void:
			##sfx_step.stop()
			#if is_instance_valid(sfx_step):
				#sfx_step.call_deferred("free")
			#isDashing= false
			#step_cooldown.start()
		#)
		
		add_child(sfx_step)
		sfx_step.play()
		
		step_time.start()
		
		await step_time.timeout
		
		if is_instance_valid(sfx_step):
			sfx_step.call_deferred("free")
		isDashing= false
		step_cooldown.start()
		#sfx_player.stream = AssetsList.SFX_DASH
		#sfx_player.play()
	
	
	
	
	var offset : float = (step_time.wait_time - step_time.time_left) / step_time.wait_time
	
	#print(offset)
	
	var dashSpeed : float = STEP_SPEED * dashCurve.sample(offset)
	
	velocity = direction * dashSpeed
	
	
	move_and_slide()

func _on_atk_timeout():
	canAttack=true

func on_steptimer_timeout():
	canDash = true
