from function import function
from neural_net import NeuralNet
import numpy as np
import matplotlib

# Przygotowanie danych uczących
X = np.linspace(-10, 10, num=200)
y = function(X)

# Tworzenie modelu
model = NeuralNet([1, 50, 1], ['linear', 'sigmoid', 'linear'])
model.build()

# Trenowanie modelu
for i in range(1000):
    for j in range(len(X)):
        model.forward(X[j])
        model.backward(y[j])

# Testowanie modelu
X_test = np.linspace(-10, 10, num=1000)
y_pred = []
for x in X_test:
    y_pred.append(model.forward(x))

# Wyświetlenie wyników
import matplotlib.pyplot as plt
plt.plot(X_test, y_pred, 'r', label='Prediction')
plt.plot(X, y, 'b', label='True function')
plt.legend()
plt.show()

