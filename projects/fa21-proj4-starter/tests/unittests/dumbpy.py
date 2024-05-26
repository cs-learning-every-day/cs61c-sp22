import numpy as np

class Matrix:
    def __init__(self, rows, cols, low=0, high=1, rand=False, seed=0):
        if rand:
            np.random.seed(seed)
            self.data = np.random.uniform(low, high, size=(rows, cols))
        else:
            self.data = np.zeros((rows, cols))

    def get(self, i, j):
        return self.data[i, j]
        
    def set(self, i, j, val):
        self.data[i,j] = val

    @property
    def shape(self):
        return self.data.shape

    def __add__(self, other):
        result = Matrix(*self.data.shape)
        result.data = self.data + other.data
        return result

    def __sub__(self, other):
        result = Matrix(*self.data.shape)
        result.data = self.data - other.data
        return result

    def __mul__(self, other):
        result = Matrix(*self.data.shape)
        result.data = self.data * other.data
        return result

    def __abs__(self):
        result = Matrix(*self.data.shape)
        result.data = np.abs(self.data)
        return result

    def __neg__(self):
        result = Matrix(*self.data.shape)
        result.data = -self.data
        return result

    def __pow__(self, power):
        result = Matrix(*self.data.shape)
        result.data = np.power(self.data, power)
        return result

    def __setitem__(self, key, value):
        self.data[kly] = value

    def __getitem__(self, key):
        return self.data[key]
