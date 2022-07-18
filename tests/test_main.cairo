%lang starknet
from src.main import sum, mean, scalar_product, median, dot, min, max, copy_to, value_into_bins, contains, digitalize, contain_count, bincount
from starkware.cairo.common.alloc import alloc


# @view
# func test_sum{}():
#     alloc_locals
#     let (local array : felt*) = alloc()
#     assert array[0] = 1
#     assert array[1] = 3
#     assert array[2] = 2

#     let (total) = sum(3, array)
#     assert total = 6
#     return ()
# end

# @view
# func test_mean{}():
#     alloc_locals
#     let (local array : felt*) = alloc()
#     assert array[0] = 9
#     assert array[1] = 7
#     assert array[2] = 8

#     let (total) = mean(3, array)
#     assert total = 8
#     return ()
# end

# @view
# func test_scalar_product{}():
#     alloc_locals
#     let (local array : felt*) = alloc()
#     assert array[0] = 1 
#     assert array[1] = 3 
#     assert array[2] = 2 

#     let (total) = scalar_product(3, 2, array)
#     assert total = 12
#     return ()
# end

# # @view
# # func test_median{}():
# #     alloc_locals
# #     let (local array : felt*) = alloc()
# #     assert array[0] = 1
# #     assert array[1] = 3
# #     assert array[2] = 2

# #     let (total) = median(3, array)
# #     assert total = 6
# #     return ()
# # end

# @view
# func test_dot{}():
#     alloc_locals
#     let (local array : felt*) = alloc()
#     assert array[0] = 1
#     assert array[1] = 3
#     assert array[2] = 2

#     let (local array1 : felt*) = alloc()
#     assert array1[0] = 4
#     assert array1[1] = 6
#     assert array1[2] = 2

#     let (total) = dot(3, array, array1)
#     assert total = 26
#     return ()
# end

# @view
# func test_min{}():
#     alloc_locals
#     let (local array : felt*) = alloc()
#     assert array[0] = 1
#     assert array[1] = 3
#     assert array[2] = 2

#     let (total) = min(3, array)
#     assert total = 1
#     return ()
# end

# @view
# func test_max{}():
#     alloc_locals
#     let (local array : felt*) = alloc()
#     assert array[0] = 1
#     assert array[1] = 3
#     assert array[2] = 2

#     let (total) = max(3, array)
#     assert total = 3
#     return ()
# end

@view
func test_copy_to{}():
    alloc_locals
    let (local array : felt*) = alloc()
    assert array[0] = 1
    assert array[1] = 3
    assert array[2] = 2
    let (local array1 : felt*) = alloc()

    copy_to(3, array, array1)
    
    assert array1[0] = array[0]
    assert array1[1] = array[1]
    assert array1[2] = array[2]
    return ()
end

@view
func test_value_into_bins{range_check_ptr : felt}():
    alloc_locals
    let (local array : felt*) = alloc()
    assert array[0] = 10
    assert array[1] = 20
    assert array[2] = 30

    let (bins1) = value_into_bins(3, array, 2)
    assert bins1 = 0
    
    let (bins2) = value_into_bins(3, array, 4)
    assert bins2 = 0
    
    let (bins3) = value_into_bins(3, array, 14)
    assert bins3 = 1
    
    let (bins4) = value_into_bins(3, array, 24)
    assert bins4 = 2
    
    let (bins5) = value_into_bins(3, array, 31)
    assert bins5 = 3
    
    return ()
end

@view
func test_digitalize{range_check_ptr : felt}():
    alloc_locals

    # case 1:
    # 0 if x < 20
    # 1 if x ≥ 20
    
    let (local array1 : felt*) = alloc()
    assert array1[0] = 2
    assert array1[1] = 4
    assert array1[2] = 4
    assert array1[3] = 7
    assert array1[4] = 12
    assert array1[5] = 14
    assert array1[6] = 19
    assert array1[7] = 20
    assert array1[8] = 24
    assert array1[9] = 31
    assert array1[10] = 34
    
    let (local bins1 : felt*) = alloc()
    assert bins1[0] = 20

    let (local new_array1 : felt*) = alloc()

    digitalize(10, array1, new_array1, 1, bins1)

    assert new_array1[0] = 0
    assert new_array1[1] = 0
    assert new_array1[2] = 0
    assert new_array1[3] = 0
    assert new_array1[4] = 0
    assert new_array1[5] = 0
    assert new_array1[6] = 0
    assert new_array1[7] = 1
    assert new_array1[8] = 1
    assert new_array1[9] = 1
    assert new_array1[10] = 1

    # case 2:
    # 0 if x < 10
    # 1 if 10 ≤ x < 20
    # 2 if x ≥ 20

    let (local array2 : felt*) = alloc()
    assert array2[0] = 2
    assert array2[1] = 4
    assert array2[2] = 4
    assert array2[3] = 7
    assert array2[4] = 12
    assert array2[5] = 14
    assert array2[6] = 20
    assert array2[7] = 22
    assert array2[8] = 24
    assert array2[9] = 31
    assert array2[10] = 34
    
    let (local bins2 : felt*) = alloc()
    assert bins2[0] = 10
	assert bins2[1] = 20

    let (local new_array2 : felt*) = alloc()

    digitalize(10, array2, new_array2, 2, bins2)

    assert new_array2[0] = 0
    assert new_array2[1] = 0
    assert new_array2[2] = 0
    assert new_array2[3] = 0
    assert new_array2[4] = 1
    assert new_array2[5] = 1
    assert new_array2[6] = 2
    assert new_array2[7] = 2
    assert new_array2[8] = 2
    assert new_array2[9] = 2
    assert new_array2[10] = 2

    # case 3:
    # 0 if x < 10
    # 1 if 10 ≤ x < 20
    # 2 if 20 ≤ x < 30
    # 3 if x ≥ 30
    let (local array : felt*) = alloc()
    assert array[0] = 2
    assert array[1] = 4
    assert array[2] = 4
    assert array[3] = 7
    assert array[4] = 12
    assert array[5] = 14
    assert array[6] = 20
    assert array[7] = 22
    assert array[8] = 24
    assert array[9] = 31
    assert array[10] = 34
    
    let (local bins : felt*) = alloc()
    assert bins[0] = 10
    assert bins[1] = 20
    assert bins[2] = 30

    let (local new_array : felt*) = alloc()

    digitalize(10, array, new_array, 3, bins)

    assert new_array[0] = 0
    assert new_array[1] = 0
    assert new_array[2] = 0
    assert new_array[3] = 0
    assert new_array[4] = 1
    assert new_array[5] = 1
    assert new_array[6] = 2
    assert new_array[7] = 2
    assert new_array[8] = 2
    assert new_array[9] = 3
    assert new_array[10] = 3

    
    return ()
end

@view
func test_contain{range_check_ptr : felt}():
    alloc_locals
    let (local array : felt*) = alloc()
    assert array[0] = 10
    assert array[1] = 20
    assert array[2] = 30

    let (contain1) = contains(10, 3, array)
    assert contain1 = 1
    
    let (contain2) = contains(20, 3, array)
    assert contain2 = 1
    
    let (contain3) = contains(30, 3, array)
    assert contain3 = 1
    
    let (contain3) = contains(1, 3, array)
    assert contain3 = 0
    
    let (contain3) = contains(31, 3, array)
    assert contain3 = 0
    
    return ()
end

@view
func test_contain_count{range_check_ptr : felt}():
    alloc_locals
    let (local array : felt*) = alloc()
    assert array[0] = 10
    assert array[1] = 20
    assert array[2] = 10

    let (contain1) = contain_count(10, 3, array)
    assert contain1 = 2
    
    return ()
end

@view
func test_bincount{range_check_ptr : felt}():
    
    alloc_locals
    
    # case 1:
    let (local array : felt*) = alloc()
    assert array[0] = 1
    assert array[1] = 6
    assert array[2] = 1
    assert array[3] = 1
    assert array[4] = 1
    assert array[5] = 2
    assert array[6] = 2

    let (local new_array : felt*) = alloc()

    bincount(7, array, new_array)
    assert new_array[0] = 0
    assert new_array[1] = 4
    assert new_array[2] = 2
    assert new_array[3] = 0
    assert new_array[4] = 0
    assert new_array[5] = 0
    assert new_array[6] = 1
    
    # case 2:
    let (local array1 : felt*) = alloc()
    assert array1[0] = 1
    assert array1[1] = 5
    assert array1[2] = 5
    assert array1[3] = 5
    assert array1[4] = 4
    assert array1[5] = 5
    assert array1[6] = 5
    assert array1[7] = 2
    assert array1[8] = 2
    assert array1[9] = 2

    let (local new_array1 : felt*) = alloc()

    bincount(10, array1, new_array1)
    assert new_array1[0] = 0
    assert new_array1[1] = 1
    assert new_array1[2] = 3
    assert new_array1[3] = 0
    assert new_array1[4] = 1
    assert new_array1[5] = 5
    assert new_array1[6] = 0
    assert new_array1[7] = 0
    assert new_array1[8] = 0
    assert new_array1[9] = 0

    return ()
end