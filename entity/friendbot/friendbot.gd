extends CharacterBody2D

@export var speed: float = 30

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var bt_player: BTPlayer = $BTPlayer

func _ready() -> void:
	bt_player.blackboard.set_var("nav_agent", navigation_agent_2d)
	
func _physics_process(_delta: float) -> void:
	sprite_2d.flip_h = velocity.x < 0
