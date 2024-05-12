from fastapi import FastAPI, HTTPException, File,  UploadFile
from pydantic import BaseModel
import joblib
import numpy as np
import random
import csv
from datetime import datetime
import json
import logging

app = FastAPI()

model_variations = {
    "sgd": {
        "model": joblib.load("../models/scikit_sgd_model.joblib"),
        "scaler": joblib.load("../models/scikit_sgd_scaler.joblib"),
    },
    "knn_randomsearch": {
        "model": joblib.load("../models/scikit_knn_model_with_hyperparameters.joblib"),
        "scaler": joblib.load("../models/scikit_knn_scaler_with_hyperparameters.joblib"),
    },
}

class Item(BaseModel):
    features: list

def log_model_call(variation, input_data, processed_data, prediction, error=None):
    log_msg = f"Model Variation: {variation}\nInput Data: {input_data}\nProcessed Data: {processed_data}\nPrediction: {prediction}\nError: {error}\n"
    logging.info(log_msg)

def write_to_csv(filename, data):
    with open(filename, mode='a', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(data)

@app.post("/predict/{variation}")
def predict(item: Item, variation: str):
    try:
        if variation not in model_variations:
            raise HTTPException(status_code=400, detail="Invalid model variation")

        model_info = model_variations[variation]
        input_data = item.features
        processed_data = model_info["scaler"].transform(np.array(input_data).reshape(1, -1))
        prediction = model_info["model"].predict(processed_data)
        log_model_call(variation, input_data, processed_data.tolist(), prediction.tolist())

        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_data = [timestamp, variation, str(prediction[0])]
        write_to_csv("model_logs.csv", log_data)

        return {"predicted_genre": str(prediction[0])}
    except Exception as e:
        log_model_call(variation, input_data, processed_data.tolist(), prediction.tolist(), error=str(e))
        raise HTTPException(status_code=500, detail=str(e))

def ab_test_single_record(record, variation):
    try:
        model_info = model_variations[variation]
        input_data = json.loads(record)
        genre = input_data["genres"][0]
        input_data = [value for key, value in input_data.items() if key not in ['genres', 'release_date', 'energy', 'mode']]
        processed_data = model_info["scaler"].transform(np.array(input_data).reshape(1, -1))
        prediction = model_info["model"].predict(processed_data)

        log_model_call(variation, input_data, processed_data.tolist(), prediction.tolist())
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_data = [timestamp, variation, str(prediction[0]), genre]
        write_to_csv("model_logs.csv", log_data)

        return {"predicted_genre": str(prediction[0])}
    except Exception as e:
        log_model_call(variation, input_data, processed_data.tolist(), prediction.tolist(), error=str(e))
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/ab_test")
async def ab_test(file: UploadFile = File(...)):
    try:
        file_content = await file.read()
        file_content.decode()
        for record in file_content.decode().splitlines():
            # randomly choose a model variation for A/B testing
            variation = random.choice(list(model_variations.keys()))
            ab_test_single_record(record, variation)
        return {"message": "Tests done, see model_logs.csv for results and analysis.py for analysis"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))   
