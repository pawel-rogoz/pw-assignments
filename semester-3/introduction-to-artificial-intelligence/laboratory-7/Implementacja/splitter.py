from dataset import Dataset
import numpy as np

class Splitter:
    def __init__(self, dataset:Dataset) -> None:
        self._data = dataset.get_data()
        self._measures = self.split_by_class()

    def split_by_class(self):
        separated = self.seperate_by_class()
        summaries = dict()
        for class_value, rows in separated.items():
            summaries[class_value] = self.split_dataset(rows)
        return summaries

    def split_dataset(self, data):
        columns_values = dict()
        for row in data:
            for index, column_value in enumerate(row):
                if index not in columns_values.keys():
                    columns_values[index] = list()
                columns_values[index].append(column_value)
        del columns_values[len(data[0])-1]
        measures = [[self.mean(columns_values[key]), self.deviation(columns_values[key]), len(columns_values[key])] for key in columns_values.keys()]
        return measures

    def seperate_by_class(self):
        seperated = dict()
        data = self._data
        for row in data:
            vector = row
            class_value = row[-1]
            if (class_value not in seperated.keys()):
                seperated[class_value] = list()
            seperated[class_value].append(vector)
        return seperated

    def deviation(self, numbers):
        avg = self.mean(numbers)
        variance = np.sum([np.square(x-avg) for x in numbers]) / float(len(numbers)-1)
        return np.sqrt(variance)

    def mean(self, numbers):
        return np.sum(numbers)/float(len(numbers))

    def get_data(self):
        return self._data

    def set_data(self, data):
        self._data = data
        self._measures = self.split_by_class()

    def get_measures(self):
        return self._measures