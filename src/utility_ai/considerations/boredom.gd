extends Consideration

var derived_value: float
# Frequency of oscillation in oscillations per second
var frequency: float = 1.0/10.0
# Internal time tracker
var time_passed: float = 0.0

func _process(delta: float) -> void:
	# Update the time passed
	time_passed += delta
	
	# Calculate the oscillating value
	# Begins at (0,0) at "bottom" of sine wave
	derived_value = 0.5 * (sin(2.0 * PI * frequency * (time_passed - .25)) + 1.0)

func get_derived_value() -> float:
	return derived_value
