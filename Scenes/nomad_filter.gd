extends RigidBody3D


@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05
@export_range(1020, 1029) var surface_seawater_density : int =  1020

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/World/WaterPlane')

#---------------- Added to calculate the bouyancy using the probes
@onready var probes = $ProbeContainer.get_children()
#-----------------------------------------------------------------
var submerged := false

const water_height := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	print(global_position.y)
	submerged = false
	
	#----------------------Code without probes-----------------------------
#	var depth = water.get_height(global_position) - global_position.y
#
#	if depth > 0:
#		submerged = true
#		apply_central_force(Vector3.UP * float_force * gravity * depth)
	#--------------------------------------------------------------------
	
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * surface_seawater_density * float_force * gravity , p.global_position - global_position)

func _integrate_forces(state:PhysicsDirectBodyState3D):
	
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag
