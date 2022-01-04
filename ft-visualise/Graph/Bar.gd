extends MeshInstance

var min_height = 0.0
var max_height = 10.0

func init(start_pos : Vector3) -> void:
	self.translation = start_pos
	self.setMaterial(
		Color(0.6, 0.98, 0.6, 1)
	)
	
func setMaterial(colour: Color) -> void:
	var material = SpatialMaterial.new()
	material.albedo_color = colour
	self.set_surface_material(0, material)

func _physics_process(delta) -> void:
	pass
