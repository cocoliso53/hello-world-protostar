%lang starknet

# Library to implement array operations.

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_le

# Compute the sum of the element in an array.
# Args:
#   input_len - length of the felt array.
#   input - felt array.
# Returns:
#   output - felt with the sum of each element of the array.
func sum(input_len : felt, input : felt*) -> (output : felt):
    if input_len == 0:
        return(0)
    end
    let (output) = sum(input_len - 1, input + 1) 
    return(output + [input])
end

# Compute the arithmetic mean along the array.
# Args:
#   input_len - length of the felt array.
#   input - felt array.
# Returns:
#   output - arithmetic mean.
func mean(input_len : felt, input : felt*) -> (output : felt):
    let (s) = sum(input_len, input)
    return(s / input_len)
end

# Compute the scalar multiplication of an array.
# Args:
#   input_len - length of the felt array.
#   scalar - felt that multiplies the array.
#   input - felt array.
# Returns:
#   output - scalar product felt.
func scalar_product(input_len : felt, scalar : felt, input : felt*) -> (output : felt):    
    if input_len == 0:
        return(0)
    end
    let (d) = scalar_product(input_len - 1, scalar, input + 1)
    return (scalar * [input] + d) 
end

# Compute the median along the array.
# Args:
#   input_len - length of the felt array.
#   vs - felt array.
# Returns:
#   output - median.
func median(input_len : felt, input : felt*) -> (med : felt):
    tempvar is_even : felt
    %{
        ids.is_even = 1 if (ids.input_len % 2 == 0) else 0
    %}
    if is_even == 1:
        return(input[input_len / 2])
    else:
        tempvar a = input[((input_len - 1) / 2) - 1]
        tempvar b = input[((input_len + 1) / 2) - 1]
        return((a + b) / 2)
    end
end

# Compute the dot product of two arrays.
# Args:
#   input_len - length of the felt arrays. If they do not have the same length an error will appear.
#   input1 - first felt array.
#   input2 - second felt array.
# Returns:
#   output - dot product felt.
func dot(input_len : felt, input1 : felt*, input2 : felt*) -> (output : felt):    
    if input_len == 0:
        return(0)
    end
    let (d) = dot(input_len - 1, input1 + 1, input2 + 1)
    return ([input1] * [input2] + d) 
end

# Obtain the minimum value in an array.
# Args:
#   input_len - length of the felt array.
#   input - felt array.
# Returns:
#   output - minimum value.
func min(input_len : felt, input : felt*) -> (output : felt):
    if input_len == 0:
        return (input[0])
    end
    let (input_len_prev) = min(input_len - 1, input)
    let min_prev = input[input_len - 1]
    tempvar output : felt
    %{
        ids.output = min(ids.input_len_prev, ids.min_prev)
    %}
    return(output)
end

# Obtain the maximum value in an array.
# Args:
#   input_len - length of the felt array.
#   input - felt array.
# Returns:
#   output - maximum value.
func max(input_len : felt, input : felt*) -> (output : felt):
    if input_len == 0:
        return (input[0])
    end
    let (input_len_prev) = max(input_len - 1, input)
    let max_prev = input[input_len - 1]
    tempvar output : felt
    %{
        ids.output = max(ids.input_len_prev, ids.max_prev)
    %}
    return(output)
end


###########################################################################################


func copy_to(input_len : felt, input : felt*, new_array : felt*) -> ():
    if input_len == 0:
        return()
    end
    assert[new_array] = input[0]
    return copy_to(input_len - 1, input + 1, new_array + 1)
end

# https://www.statology.org/numpy-digitize/
func digitalize{range_check_ptr : felt}(input_len : felt, input : felt*, new_array : felt*, bins_len : felt, bins : felt*) -> ():
    if input_len == 0:
        return()
    end
    let (bin) = value_into_bins(bins_len, bins, input[0]) 
    assert[new_array] = bin
    return digitalize(input_len - 1, input + 1, new_array + 1, bins_len , bins)
end

func value_into_bins{range_check_ptr : felt}(bins_len : felt, bins : felt*, value : felt) -> (bins : felt):
    
    if bins_len == 0:
        return(0)
    end

    # revisar el value + 1, es por la condicion is_le
    let (is_minor) = is_le(value + 1, [bins + bins_len - 1])
    if is_minor == 1:
        return value_into_bins(bins_len - 1, bins, value)
    else:
        return (bins_len)
    end
end

# https://es.acervolima.com/numpy-bincount-en-python/
func bincount(input_len : felt, input : felt*, new_array : felt*) -> ():
    _bincount(input_len, input_len, input, new_array, 0)
    return()
end

func _bincount(i :felt, input_len : felt, input : felt*, new_array : felt*, idx : felt) -> ():
    if i == 0:
        return()
    end
    let (count) = contain_count(idx, input_len, input)
    assert[new_array] = count
    return _bincount(i - 1, input_len, input, new_array + 1, idx + 1)
end

func contain_count(value : felt, input_len : felt, input : felt*) -> (result : felt):
    alloc_locals
    if input_len == 0:
        return(0)
    end
    local t
    if value == input[0]:
        t = 1
    else:
        t = 0
    end
    let (local total) = contain_count(value, input_len - 1, input + 1)
    return (t + total)
end

func contains(value : felt, input_len : felt, input : felt*) -> (result : felt):
    if input_len == 0:
        return(0)
    end

    if value == input[0]:
        return (1)
    else:
        return contains(value, input_len - 1, input + 1) 
    end
end

