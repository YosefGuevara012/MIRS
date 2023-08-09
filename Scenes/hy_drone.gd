extends RigidBody3D

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/World/WaterPlane')

@onready var probes = $ProbeContainer.get_children()

#Vehicle controller variables
var velocity = Vector3(0,0,0)
var speed = 3.0

# Water Effect varibles
var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	#Vehicle controller
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = 0.5
	if Input.is_action_pressed("ui_left"):
		velocity.x = -0.5
	if Input.is_action_pressed("ui_up"):
		velocity.z = -0.5
	if Input.is_action_pressed("ui_down"):
		velocity.z = 0.5
		
	move_and_collide(velocity)
	
	#Water affect
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 