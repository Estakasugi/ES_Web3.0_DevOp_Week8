def replaceElements(arr):

    m = -1
    for i in range(len(arr)-1,-1,-1):
        if arr[i]>m :
            m, arr[i] = arr[i], m
        else:
            arr[i] = m
    return arr