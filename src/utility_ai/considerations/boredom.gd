extends Consideration

var derived_value := 0.0
# Frequency of oscillation in oscillations per second
var frequency: float = 1.0/5.0
# Internal time tracker
var time_passed: float = 0.0

func _process(delta: float) -> void:
	# Update the time passed
	time_passed += delta
	
	# Calculate the oscillating value
	derived_value = .25 * (cos(2.0 * PI * frequency * time_passed) + 1)

func get_derived_value() -> float:
	return derived_value
