import numpy as np


class Perceptron:
    def __init__(self, num_inputs, num_hidden_layers, num_neurons_per_layer, num_outputs, activation_function='sigmoid', optimizer='gradient_descent'):
        self.num_inputs = num_inputs
        self.num_hidden_layers = num_hidden_layers
        self.num_neurons_per_layer = num_neurons_per_layer
        self.num_outputs = num_outputs
        self.activation_function = activation_function
        self.optimizer = optimizer

        # Inicjalizacja wag sieci
        self.weights = []
        self.biases = []
        # Warstwy ukryte
        for i in range(self.num_hidden_layers):
            # Inicjalizacja wag i biasów dla warstwy ukrytej
            w = np.random.randn(self.num_neurons_per_layer,
                                self.num_neurons_per_layer)
            b = np.random.randn(self.num_neurons_per_layer)
            self.weights.append(w)
            self.biases.append(b)
        # Warstwa wyjściowa
        w = np.random.randn(self.num_outputs, self.num_neurons_per_layer)
        b = np.random.randn(self.num_outputs)
        self.weights.append(w)
        self.biases.append(b)

    def forward_propagation(self, inputs):
        # Przepływ danych przez sieć
        self.z = []  # wektory wyjść z warstw
        self.a = []  # wektory aktywacji z warstw
        self.a.append(inputs)
        for i in range(self.num_hidden_layers+1):
            z = np.dot(self.weights[i], self.a[i]) + self.biases[i]
            if i < self.num_hidden_layers:
                a = self._activate(z)  # aktywacja dla warstw ukrytych
            else:
                a = z  # warstwa wyjściowa bez aktywacji
            self.z.append(z)
            self.a.append(a)
        return a

    def _activate(self, z):
        # Funkcja aktywacji dla warstw ukrytych
        if self.activation_function == 'sigmoid':
            return 1 / (1 + np.exp(-z))
        elif self.activation_function == 'tanh':
            return np.tanh(z)
        elif self.activation_function == 'relu':
            return np.maximum(0, z)
        else:
            raise ValueError('Nieznana funkcja aktywacji')

    def train(self, inputs, targets, num_iterations, learning_rate):
        for iteration in range(num_iterations):
            # Przepływ danych przez sieć
            outputs = self.forward_propagation(inputs)

            # Obliczenie błędu aproksymacji
            error = self._calculate_error(targets, outputs)

            # Obliczenie gradientów wag i biasów
            self._backpropagation(inputs, targets, outputs, learning_rate)

            if iteration % 1000 == 0:
                print(f'Iteracja {iteration}: błąd = {error}')

    def _calculate_error(self, targets, outputs):
        # Obliczenie błędu aproksymacji (np. błąd średniokwadratowy)
        return np.mean((targets - outputs)**2)

    def _backpropagation(self, inputs, targets, outputs, learning_rate):
        # Obliczenie gradientów wag i biasów za pomocą algorytmu gradientowego spadku wstecznego

        # Obliczenie gradientu warstwy wyjściowej
        output_errors = targets - outputs
        output_gradients = output_errors * \
            self._activate_derivative(self.z[-1])
        output_deltas = learning_rate * np.dot(output_gradients, self.a[-2].T)

        # Obliczenie gradientów warstw ukrytych
        hidden_errors = []
        hidden_gradients = []
        hidden_deltas = []
        for i in reversed(range(self.num_hidden_layers)):
            errors = np.dot(self.weights[i+1].T, output_errors)
            gradients = errors * self._activate_derivative(self.z[i])
            deltas = learning_rate * np.dot(gradients, self.a[i-1].T)
            hidden_errors.insert(0, errors)
            hidden_gradients.insert(0, gradients)
            hidden_deltas.insert(0, deltas)
            output_errors = errors
            output_gradients = gradients

        # Aktualizacja wag i biasów
        self.weights[-1] += output_deltas
        self.biases[-1] += output_gradients
        for i in range(self.num_hidden_layers):
            self.weights[i] += hidden_deltas[i]
            self.biases[i] += hidden_gradients[i]

    def _activate_derivative(self, z):
        # Pochodna funkcji aktywacji dla warstw ukrytych
        if self.activation_function == 'sigmoid':
            return self._activate(z) * (1 - self._activate(z))
        elif self.activation_function == 'tanh':
            return 1 - self._activate(z)**2
        elif self.activation_function == 'relu':
            return np.where(z > 0, 1, 0)
        else:
            raise ValueError('Nieznana funkcja aktywacji')
