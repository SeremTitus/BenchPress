# ⚠ No need edit this file, modify in Benchpress Editor 🤖

# imports
import sys
import socket
import json

# user globals

# ActionCall globals
hello = None

# debugger globals
client_socket_2 = None

# Subroutines
def Main():
	built_in_print_hello(hll = "new val", global_output = ["hello", ])
	# debugger call 
	debugger_debug_Subroutine(Subroutine_name = "Main", step = 0, globals_changed = ["hello"], global_output = ["client_socket_2", ])

# Actions
def built_in_print_hello(hll,global_output = []):
	try:
		print(globals()[global_output[0]])
		print(hll)
	except Exception as e:
		print(f"An unexpected error occurred: {e}")
		# debugger call 
		debugger_debug__Action(library_name = "built_in", title_name = "print_hello", exception = e, global_output = ["client_socket_2", ])


# _debugger Actions
def debugger_debug_UDPClient(global_output = []):

	if len(sys.argv) > 1:
		address = sys.argv[1].split(':')
		if address[0] == "*" or address[0] == "":
			server_address = ("localhost", int(address[1]))
		else:
			server_address = (address[0], int(address[1]))
		globals()[global_output[0]] = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		try:
			globals()[global_output[0]].connect(server_address)
		except Exception as e:
			print("Socket Conection Failed:",e)


def debugger_debug_Subroutine(Subroutine_name,step,globals_changed,global_output = []):

	return_globals_changed = {}
	for global_var in globals_changed:
		return_globals_changed[global_var] = globals()[global_var]
	data_to_send = {
		"Type": "DebugSubroutine",
		"FilePath": sys.argv[0],
		"SubroutineName": Subroutine_name,
		"Step": step,
		"GlobalsChanged":return_globals_changed,
		}
	json_data = json.dumps(data_to_send)
	try:
		globals()[global_output[0]].sendall(json_data.encode())
	except:
		print("Socket Conection Failed")


def debugger_debug__Action(library_name,title_name,exception,global_output = []):

	data_to_send = {
		"Type": "DebugSubroutine",
		"FilePath": sys.argv[0],
		"LibraryName": library_name,
		"TitleName": title_name,
		"Exception": exception
		}
	json_data = json.dumps(data_to_send)
	try:
		globals()[global_output[0]].sendall(json_data.encode())
	except:
		print("Socket Conection Failed")



# Call main Subroutine
if __name__ == "__main__":
	# debugger call 
	debugger_debug_UDPClient(global_output = ["client_socket_2", ])
	Main()