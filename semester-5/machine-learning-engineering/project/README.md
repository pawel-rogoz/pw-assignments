# Usage of microservice
    cd microservice/
    uvicorn app:app --reload

    http POST http://127.0.0.1:8000/predict/sgd features:='[45, 260000, 0, 0.6, 3, -6, 0.1, 0.2, 0.0, 0.3, 0.8, 120, 4]'
    http POST http://127.0.0.1:8000/predict/knn_randomsearch features:='[45, 260000, 0, 0.6, 3, -6, 0.1, 0.2, 0.0, 0.3, 0.8, 120, 4]'

    http --form POST http://localhost:8000/ab_test file@tracks_with_genre_tests.jsonl