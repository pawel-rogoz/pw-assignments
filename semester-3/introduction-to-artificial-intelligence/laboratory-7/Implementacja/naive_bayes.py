from dataset import Dataset
from splitter import Splitter
import numpy as np

class NaiveBayes:
    def __init__(self, dataset:Dataset, splitter:Splitter, n_parts:int) -> None:
        self._splitter = splitter
        self._parts_number = n_parts
        self._dataset = dataset
        self._data = splitter.get_data()
        self._measures = splitter.get_measures()
        self._accuracy = self.test_algorithm()

    def __str__(self) -> str:
        accuracy = round(np.sum(self._accuracy) / float(len(self._accuracy)), 2)
        return f'Average accuracy for this dataset split to {self._parts_number - 1} train sets is: {accuracy}%'

    def test_algorithm(self):
        parts = self.train_data_creator()
        scores = list()
        for part in parts:
            train_set = list(parts)
            train_set.remove(part)
            train_set = sum(train_set, [])
            test_set = list()
            for row in part:
                row_copy = list(row)
                test_set.append(row_copy)
                row_copy[-1] = None
            predicted = self.naive_bayes(train_set, test_set)
            actual = [row[-1] for row in part]
            accuracy = self.accuracy(actual, predicted)
            scores.append(accuracy)
        return scores

    def train_data_creator(self):
        splitted = list()
        dataset_copy = list(self._data)
        n_parts = self._parts_number
        part_size = int(len(dataset_copy) / n_parts)
        for _ in range(n_parts):
            part = list()
            while len(part) < part_size:
                index = np.random.choice(len(dataset_copy), 1)[0]
                part.append(dataset_copy.pop(index))
            splitted.append(part)
        return splitted

    def naive_bayes(self, train, test):
        self._splitter.set_data(train)
        predictions = list()
        for row in test:
            output = self._predict(row)
            predictions.append(output)
        return(predictions)

    def calculate_probability(self, x, mean, deviation):
        exponent = np.exp(-((x-mean)**2 / (2 * np.square(deviation) )))
        return (1 / (np.sqrt(2 * np.pi) * deviation)) * exponent

    def calculate_class_probabilities(self, row):
        summaries = self._splitter.get_measures()
        total_rows = sum([summaries[label][0][2] for label in summaries])
        probabilities = dict()
        for class_value, class_summaries in summaries.items():
            probabilities[class_value] = summaries[class_value][0][2]/float(total_rows)
            for i in range(len(class_summaries)):
                mean, deviation, _ = class_summaries[i]
                probabilities[class_value] *= self.calculate_probability(row[i], mean, deviation)
        return probabilities

    def _predict(self, row):
        probabilities = self.calculate_class_probabilities(row)
        best_label, best_prob = None, -np.inf
        for class_value, probability in probabilities.items():
            if best_label is None or probability > best_prob:
                best_prob = probability
                best_label = class_value
        return best_label

    def predict(self, row):
        best_label = self._predict(row)
        title_values = self._dataset.get_title_values()
        for title in title_values.keys():
            if best_label == title_values[title]:
                best_label_title = title
        return f'Predicted plant: {best_label_title}'

    def accuracy(self, actual, predicted):
        correct = 0
        for i in range(len(actual)):
            if actual[i] == predicted[i]:
                correct += 1
        return correct / float(len(actual)) * 100.0

    def get_accuracy(self):
        return self._accuracy
