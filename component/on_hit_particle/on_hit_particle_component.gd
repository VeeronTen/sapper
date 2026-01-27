class_name OnHitParticleComponent
extends Node2D

@onready var _gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func emit() -> void:
	_gpu_particles_2d.emitting = true
