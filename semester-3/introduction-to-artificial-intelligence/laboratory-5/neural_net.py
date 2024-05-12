import numpy as np

class NeuralNet:
    def __init__(self, layer_sizes, activations):
        """
        Inicjalizacja sieci neuronowej.
        
        Parameters
        ----------
        layer_sizes: list
            Lista zawierająca liczbę neuronów w każdej warstwie sieci.
        activations: list
            Lista zawierająca rodzaj aktywacji dla każdej warstwy sieci.
        """
        self.layer_sizes = layer_sizes
        self.activations = activations
        self.weights = []
        self.biases = []
        self.layers = []
        self.output = []
        
    def add_layer(self, layer_size, activation):
        """
        Dodaje warstwę sieci.
        
        Parameters
        ----------
        layer_size: int
            Liczba neuronów w warstwie.
        activation: str
            Rodzaj aktywacji w warstwie.
        """
        self.layer_sizes.append(layer_size)
        self.activations.append(activation)
        
    def build(self):
        """
        Inicjalizuje wagi i bias dla każdej warstwy sieci.
        """
        for i in range(len(self.layer_sizes) - 1):
            self.weights.append(np.random.randn(self.layer_sizes[i], self.layer_sizes[i+1]))
            self.biases.append(np.random.randn(self.layer_sizes[i+1]))
            
    def forward(self, input_data):
        """
        Przeprowadza inferencję (predykcję) dla danych wejściowych.
        
        Parameters
        ----------
        input_data: array-like
            Wektor zawierający dane wejściowe.
        
        Returns
        -------
        output: array-like
            Wektor zawierający wynik inferencji.
        """
        self.layers = []
        self.output = input_data
        self.layers.append(input_data)
        for i in range(len(self.layer_sizes) - 1):
            self.output = np.dot(self.output, self.weights[i]) + self.biases[i]
            if self.activations[i+1] == 'sigmoid':
                self.output = 1 / (1 + np.exp(-self.output))
            elif self.activations[i+1] == 'relu':
                self.output = np.maximum(0, self.output)
            self.layers.append(self.output)
        return self.output


