# cairo-compile linear_function.cairo --output linear_function_compiled.json
# cairo-run --program=linear_function_compiled.json --program_input=linear_function_input.json --print_output --layout=small

%builtins output

from starkware.cairo.common.serialize import serialize_word, serialize_array
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.registers import get_fp_and_pc,get_label_location


func linear_function(inputs: felt*, weights: felt*, size) -> (sum):
	if size == 0:
		return (sum=0)
	end
	
	let (sum_of_rest) = linear_function(inputs=inputs+1, weights=weights+1, size=size-1)
	return (sum=[inputs]*[weights] + sum_of_rest)
end

#func my_cb(a: felt, b: T*) -> (ret):
#	return(ret=a)
#end

func main{output_ptr: felt*}():
	alloc_locals

	local weights : felt* 
	local inputs : felt* 	
	local size
	
	%{weight_list = program_input['weights']
ids.weights = weights = segments.add()
for i, val in enumerate(weight_list):
	memory[weights + i] = val
input_list = program_input['inputs']
ids.inputs = inputs = segments.add()
for i, val in enumerate(input_list):
	memory[inputs + i] = val	
ids.size = len(input_list)	
	%}
	#serialize_array(inputs,size,1,get_label_location('serialize_word'))
	#serialize_array(weights,size,1,get_label_location('serialize_word'))	
	let (sum) = linear_function(inputs=inputs, weights=weights, size=size)
	
	serialize_word(sum)
	return()
end
