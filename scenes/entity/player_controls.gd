extends CharacterBody3D

@export var dashCurve : Curve

@export var camera: Camera3D


@onready var step_cooldown: Timer = $stepCooldown
@onready var step_time: Timer = $stepTime


const SPEED = 9.0
const STEP_SPEED = 68.0
const JUMP_VELOCITY = 4.5

#dont feel like using them yet
enum MoveStates {IDLE, MOVING, DASH}
enum AttackStates {ATTACK, GRAPPLE, SLINGSHOT}



var canDash: bool = true

var isDashing: bool = false

var input_dir : Vector2

func _ready() -> void:
	step_cooldown.timeout.connect(on_steptimer_timeout)

func _input(event: InputEvent) -> void:
	
	
	if Input.is_action_just_pressed("bigstep"):
		if canDash:
			isDashing = true
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP, deg_to_rad(45))
	
	if isDashing:
		do_big_step(direction)
		return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_x := Input.get_axis("move_a", "move_d")
	#var input_y := Input.get_axis("move_w", "move_s")
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

func do_big_step(direction: Vector3) -> void:
	#if !canDash: return
	
	# ============== DASHING LOGIC ==============
	
	
	canDash = false
	
	
	
	if step_time.is_stopped():
		step_time.start()
		step_time.timeout.connect(func()->void: isDashing= false; step_cooldown.start())
	
	if !direction:
		print("no direction")
		return
	
	var offset : float = (step_time.wait_time - step_time.time_left) / step_time.wait_time
	
	#print(offset)
	
	var dashSpeed : float = STEP_SPEED * dashCurve.sample(offset)
	
	
	
	velocity = direction * dashSpeed
	
	
	
	
	
	move_and_slide()

func on_steptimer_timeout():
	canDash = true
