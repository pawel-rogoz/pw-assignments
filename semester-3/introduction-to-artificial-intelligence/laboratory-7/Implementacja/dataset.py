import csv
import numpy as np

class Dataset:
    def __init__(self, filename) -> None:
        self._data = self.read_from_csv(filename)
        self._title_values = self.seperate_data_by_title()

    # def __str__(self) -> str:
    #     title_values = self._title_values
    #     final_str = f'{title_values}'
    #     final_str += '\n'
    #     for index, row in enumerate(self._data):
    #         for column in range(len(row)-1):
    #             final_str += f'{self._data[index][column]} '
    #         final_str += f'{self._data[index][len(row)-1]}\n'
    #     return final_str

    def read_from_csv(self, filename):
        data = []
        with open(filename, 'r') as file:
            csvreader = csv.reader(file)
            for row in csvreader:
                data.append(row)
        data = self.change_values(data)
        return data

    def change_values(self, data):
        for row_index, row in enumerate(data):
            values = row[:-1]
            for column_index, value in enumerate(values):
                data[row_index][column_index] = float(value)
        return data

    def seperate_data_by_title(self):
        data = self.get_data()
        all_titles = [row[-1] for row in data]
        titles = set(all_titles)
        title_dict = dict()
        for value, title in enumerate(titles):
            title_dict[title] = value
        for row in data:
            row[-1] = title_dict[row[-1]]
        self.set_data(data)
        return title_dict

    def set_data(self, data):
        self._data = data

    def get_data(self):
        return self._data

    def get_title_values(self):
        return self._title_values