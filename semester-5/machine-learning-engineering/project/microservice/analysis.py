import csv

knn_total_count = 0
knn_correct_count = 0
sgd_total_count = 0
sgd_correct_count = 0

with open('model_logs.csv', 'r') as file:
    csv_reader = csv.reader(file)
    for row in csv_reader:
        if row[1] == 'knn_randomsearch':
            knn_total_count += 1
            if row[-1] == row[-2]:
                knn_correct_count += 1

        elif row[1] == 'sgd':
            sgd_total_count += 1
            if row[-1] == row[-2]:
                sgd_correct_count += 1

print(f"Liczba wszystkich klasyfikacji dla knn_randomsearch: {knn_total_count}")
print(f"Liczba poprawnych klasyfikacji dla knn_randomsearch: {knn_correct_count}")
print(f"Procentowa poprawność dla knn_randomsearch: {knn_correct_count / knn_total_count * 100:.2f}%")

print(f"\nLiczba wszystkich klasyfikacji dla sgd: {sgd_total_count}")
print(f"Liczba poprawnych klasyfikacji dla sgd: {sgd_correct_count}")
print(f"Procentowa poprawność dla sgd: {sgd_correct_count / sgd_total_count * 100:.2f}%")
