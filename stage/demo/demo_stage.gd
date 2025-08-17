extends Node2D
#todo тайлмап
#todo паралакс
#todo tweener
#todo backBufferCopy
#todo ресурсы кастомные
#todo локализация
#todo сохранение загрузка
#todo канвас группа
#todo кисть которая рандомные обьекты хуярит или рандомные параметры, может в тайлмапе есть
#todo искуственный интеллект на стейт машине или дереве
#todo глубже понять авейт и корутины
#todo https://www.youtube.com/watch?v=ilPYnRAzOAs&list=PL5JAIkkN8dnT7h1Qok0NfskfRHGfkr9tG&index=20
#todo Perspective in Top down
#todo better terrain
#todo uid (можн охранить в статик поле файла, рядом с которым лежит)
#todo сигналы можно привязывать к своим методам, но можно ли несколько сигналов привязать к одному методу? Что лучше, делать явные функции обработки сигналов или все привязывать через движок и смотреть тулзой че куда
#todo Сакутин говорил, что можно конфиг ноды в сцене унести в отдельный файл, чтоб сцену было легче множить. Как? И ещё и какие Бест практис для совместной разработке игр. Особенно в годоте

@onready var _sapper: Sapper = %Sapper
@onready var _light_gun: LightGun = %LightGun

func _ready() -> void:
	DebugDraw2D.config.text_default_size = 25
	
func _on_demo_controls_is_moving_changed(is_moving: bool) -> void:
	_sapper.is_moving = is_moving

func _on_demo_controls_move_direction_changed(direction: Vector2) -> void:
	_sapper.move_direction = direction

func _on_demo_controls_pointer_position_changed(pointer: Vector2) -> void:
	_light_gun.pointer_position = pointer
	_sapper.watch_position = pointer
