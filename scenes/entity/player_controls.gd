extends CharacterBody3D

@export var camera: Camera3D


const SPEED = 6.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_x := Input.get_axis("move_a", "move_d")
	var input_y := Input.get_axis("move_w", "move_s")
	#var input_dir := Input.get_vector("move_a", "move_d", )
	#var direction := (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction := (Vector3(input_x, 0, input_y)).normalized().rotated(Vector3.UP, deg_to_rad(45))
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		#print(velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
