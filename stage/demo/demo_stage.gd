extends Node2D
#todo тайлмап
#todo паралакс
#todo tweener
#todo backBufferCopy
#todo нарезать атлас на анимации и все такое
#todo ресурсы кастомные
#todo локализация
#todo сохранение загрузка
#todo канвас группа
#todo использовать %
#todo контрл при переноске
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

func _on_demo_controls_is_moving_changed(is_moving: bool) -> void:
	_sapper.is_moving = is_moving

func _on_demo_controls_move_direction_changed(direction: Vector2) -> void:
	_sapper.direction = direction
