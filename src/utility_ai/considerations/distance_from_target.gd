extends Consideration

## To be implemented in instance of Consideration class.
func calculate_derived_value() -> float:
	return 0.0

## Receieve requested data from Dictionary of data (usually GameState's 
## game_state_data variable).
func receive_data(data_key, data):
	game_values[data_key] = data.get(data_key)
	print("Data received: %s : %s", [data_key, data.to_string()]) # Debug

## To be implemented in instanced Consideration; generic implementation
## commented below.
func request_data():
	#data_requested.emit(data_key, self)
	pass
