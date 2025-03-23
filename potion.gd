extends Node2D

@export var color_ramp: GradientTexture1D
@export var amount: int = 16
@export var lifetime: float = 2.0
@export var liquid_color: Color
@export var texture: Texture
@export var level_unlock: int # Ab welchem Level kann der Trank als Quest vorkommen?
@export var level_master: int # Ab welchem Level kennt man alle Infos?

@onready var potionshader: Sprite2D = $Potionshader
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D


func _ready() -> void:
	# Erstelle ein ShaderMaterial und setze es einzigartig
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	shader_material.shader = preload("res://shaders/potion.gdshader")  # Dein Shader
	shader_material.set_shader_parameter("liquid_color", liquid_color)
	shader_material.set_shader_parameter("wave_speed", randf_range(0.5, 12.0))
	shader_material.set_shader_parameter("wave_amplitude", randf_range(1.0, 18.0))
	shader_material.set_shader_parameter("noise_scale", randf_range(0.0, 0.50))
	shader_material.set_shader_parameter("liquid_level", randf_range(0.0, 1.0))
	
	potionshader.material = shader_material.duplicate() # Unique machen
	
	# Erstelle einen Partikel-Knoten
	#gpu_particles_2d.texture = preload("res://assets/particles/star_01.png")  # Setze Partikeltextur
	#gpu_particles_2d.texture = particles.pick_random()
	gpu_particles_2d.texture = texture
	
	gpu_particles_2d.amount = amount  # Anzahl der Partikel
	gpu_particles_2d.lifetime = lifetime
	#gpu_particles_2d.emitting = true
	
	var base_material: Resource = preload("res://particles/red_starts.tres")  # Lade dein Partikelmaterial
	var unique_material: Resource = base_material.duplicate(true)  # Klone es, um eine neue Instanz zu haben

	# Partikel-Material erstellen
	#var particle_material = ParticleProcessMaterial.new()
	#particle_material.gravity = Vector3(0, 100, 0)  # Beispielhafte Gravitation
	unique_material.color_ramp = color_ramp  # Farbverlauf setze

	# Stelle sicher, dass das Material einzigartig ist
	gpu_particles_2d.process_material = unique_material
	
