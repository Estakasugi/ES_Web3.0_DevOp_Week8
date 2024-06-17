"""
LC-1346. Check If N and Its Double Exist
Given an array arr of integers, check if there exist two indices i and j such that :

i != j
0 <= i, j < arr.length
arr[i] == 2 * arr[j]
 

Example 1:

Input: arr = [10,2,5,3]
Output: true
Explanation: For i = 0 and j = 2, arr[i] == 10 == 2 * 5 == 2 * arr[j]
Example 2:

Input: arr = [3,1,7,11]
Output: false
Explanation: There is no i and j that satisfy the conditions.
"""

class Solution(object):
    def checkIfExist(self, arr):
        """
        :type arr: List[int]
        :rtype: bool
        """
        doubleDictionary = {}
        for num in arr:
            doubleDictionary[num] = True

        zeroCt = 0
        for num in arr:
            if (2 * num in doubleDictionary) and (num!=0):
                print(num)
                return True

            if (num == 0) and (zeroCt == 0):
                zeroCt += 1
                continue

            if (num == 0) and (zeroCt == 1):
                return True

        return False
