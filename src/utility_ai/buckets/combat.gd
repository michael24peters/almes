extends Bucket

var attitude = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the timer
	var timer = Timer.new()
	timer.wait_time = 5.0 # Set the timer to trigger every 10 seconds
	timer.autostart = true # Start the timer automatically
	timer.one_shot = false # Repeat the timer
	add_child(timer)
	
	# Connect the timeout signal to a function
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func check_active():
	if attitude >= 0: is_active = false
	elif attitude < 0: is_active = true

# Function called every time the timer times out
func _on_timer_timeout():
	attitude *= -1
