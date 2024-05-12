import numpy as np

def function(x):
    return x**2 * np.sin(x) + 100 * np.sin(x) * np.cos(x)

x = np.linspace(-10, 10, 20)
print(x)