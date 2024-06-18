"""
Given an array of integers arr, return true if and only if it is a valid mountain array.

Recall that arr is a mountain array if and only if:

arr.length >= 3
There exists some i with 0 < i < arr.length - 1 such that:
arr[0] < arr[1] < ... < arr[i - 1] < arr[i] 
arr[i] > arr[i + 1] > ... > arr[arr.length - 1]

Example 1:

Input: arr = [2,1]
Output: false
Example 2:

Input: arr = [3,5,5]
Output: false
Example 3:

Input: arr = [0,3,2,1]
Output: true
"""

def validMountainArray(arr):
    """
    :type arr: List[int]
    :rtype: bool
    """
    if len(arr) < 3:
        return False
    if arr[1] < arr[0]:
        return False

    decreaceFlag = False
    for i in range(1,len(arr)):
        if arr[i] == arr[i-1]:
            # print("equal at" + str(arr[i]))
            return False
        if arr[i] < arr[i-1]:
            decreaceFlag = True
            # print("decreasing at" + str(arr[i]))
        if (arr[i] > arr[i-1]) and (decreaceFlag):
            # print("did not decrease consistantly")
            return False
    
    if decreaceFlag == False:
        return False

    return True

ans = validMountainArray([0,2,3,3,5,2,1,0])
ans2 = validMountainArray([0,2,3,4,5,2,1,0])
ans3 = validMountainArray([2,1])
ans4 = validMountainArray([3,5,5])
ans5 = validMountainArray([0,3,2,1])
ans6 = validMountainArray([7])
ans7 = validMountainArray([0,1,2,3,4,5,6,7,8,9])
ans8 = validMountainArray([9,8,7,6,5,4,3,2,1,0])
print(ans8)