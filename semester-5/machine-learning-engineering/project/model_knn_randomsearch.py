from sklearn.model_selection import train_test_split, RandomizedSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
from jsonOperations import *
import joblib

data = getObjectsFromJson('data/new_tracks_with_genre.jsonl')

features = []
labels = []

for song in data:
    features.append([song["popularity"], song["duration_ms"], song["explicit"], song["danceability"], song["key"], song["loudness"], song["speechiness"], song["acousticness"], song["instrumentalness"], song["liveness"], song["valence"], song["tempo"], song["time_signature"]])
    labels.append(song["genres"][0])

X_train, X_test, y_train, y_test = train_test_split(features, labels, test_size=0.2, random_state=42)

scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)
knn_classifier = KNeighborsClassifier()
param_dist = {
    'n_neighbors': [3, 5, 7, 9, 11, 13],
    'weights': ['uniform', 'distance'],
    'algorithm': ['auto', 'ball_tree', 'kd_tree', 'brute'],
    'p': [1, 2],
}

random_search = RandomizedSearchCV(knn_classifier, param_distributions=param_dist, n_iter=10, cv=5, n_jobs=1, random_state=42)
random_search.fit(X_train, y_train)
print("Najlepsze hiperparametry:", random_search.best_params_)

best_knn_classifier = random_search.best_estimator_
y_pred = best_knn_classifier.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f"Dokładność modelu: {accuracy}")

joblib.dump(best_knn_classifier, "models/scikit_knn_model_with_hyperparameters.joblib")
joblib.dump(scaler, "models/scikit_knn_scaler_with_hyperparameters.joblib")