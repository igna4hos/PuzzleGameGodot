extends Node

# Простая система локализации
# Автоопределяет язык по системной локали

# Получить текст "NEW GAME" на нужном языке
func get_new_game_text() -> String:
	var system_locale = OS.get_locale()
	if system_locale.begins_with("ru"):
		return "НОВАЯ ИГРА"
	else:
		return "NEW GAME"
