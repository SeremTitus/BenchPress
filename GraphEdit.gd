extends GraphEdit

var linked_chains:Array = []

func _on_disconnection_request(from_node, from_port, to_node, to_port):
	for idx in range(0,len(linked_chains)):
		if idx < len(linked_chains) and from_node in linked_chains[idx] and to_node in linked_chains[idx]:
			var from_idx =linked_chains[idx].find(from_node)
			var to_idx =linked_chains[idx].find(to_node)
			if from_idx == 0:# remove back
				linked_chains[idx].pop_at(0)
			elif to_idx == len(linked_chains[idx])-1:# remove front
				linked_chains[idx].pop_at(len(linked_chains[idx])-1)
			else:# slice
				linked_chains.append(linked_chains[idx].slice(0,to_idx))
				linked_chains.append(linked_chains[idx].slice(to_idx))
				linked_chains.pop_at(idx)
			if len(linked_chains[idx]) == 1 :
				linked_chains.pop_at(idx)
	print(linked_chains)
	disconnect_node(from_node, from_port, to_node, to_port)

func _on_connection_request(from_node, from_port, to_node, to_port):
	if from_node == to_node : return
	var ActionCall_chain = get_connection_list()
	for idx in range(len(ActionCall_chain)):
		if ActionCall_chain[idx].from_node == from_node:#Foward once
			_on_disconnection_request(ActionCall_chain[idx].from_node, ActionCall_chain[idx].from_port,\
				ActionCall_chain[idx].to_node, ActionCall_chain[idx].to_port)
	if len(linked_chains) == 0:
		linked_chains.append([from_node,to_node])
	else:
		for idx in range(0,len(linked_chains)):
			if idx < len(linked_chains) and from_node in linked_chains[idx] and to_node in linked_chains[idx]:
				return
		var append = false
		for idx in range(0,len(linked_chains)):
			if idx < len(linked_chains) and from_node in linked_chains[idx] and  not to_node in linked_chains[idx]:
				var currentChain = linked_chains[idx]
				for sec_idx in range(0,len(linked_chains)):
					if sec_idx < len(linked_chains) and to_node in linked_chains[sec_idx]:
						if to_node == linked_chains[idx][0]:
							append = true
							linked_chains[idx] = currentChain + linked_chains[sec_idx]
							break
						else:
							append = true
							var new_currentChain = linked_chains[sec_idx].slice(linked_chains[idx].find(to_node))
							linked_chains[idx] = currentChain + new_currentChain
							break
				if not append:
					append = true
					linked_chains[idx].insert(linked_chains[idx].find(from_node) + 1 ,to_node)
					break
				else:
					break
		if not append:
			for idx in range(0,len(linked_chains)):
				if idx < len(linked_chains) and to_node in linked_chains[idx]  and not from_node in linked_chains[idx]:
					if to_node == linked_chains[idx][0]:
						append = true
						linked_chains[idx].insert(linked_chains[idx].find(to_node),from_node)
						break
					else:
						append = true
						var currentChain = linked_chains[idx].slice(linked_chains[idx].find(to_node))
						currentChain.insert(0,from_node)
						linked_chains.append(currentChain)
						break
		if not append:
			linked_chains.append([from_node,to_node])
	print(linked_chains)
	connect_node(from_node, from_port, to_node, to_port)
