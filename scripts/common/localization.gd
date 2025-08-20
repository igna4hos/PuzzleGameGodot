extends Node

# Simple localization helper
# Previously auto-detected system locale; now always returns English text

# Get text for "NEW GAME" (always English)
func get_new_game_text() -> String:
	var system_locale = OS.get_locale()
	# Always return English label regardless of locale
	return "NEW GAME"
