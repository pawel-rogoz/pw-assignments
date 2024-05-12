import json
import random
from datetime import datetime, timedelta

def add_integer_noise(value, noise_factor=5):
    noise = random.randint(-noise_factor, noise_factor)
    return value + noise

def add_float_noise(value, noise_factor=0.05):
    noise = random.uniform(-noise_factor, noise_factor)
    return round(value + noise, 3)

def change_release_date(value, noise_factor=0.05):
    date_format = "%Y-%m-%d"
    try:
        original_date = datetime.strptime(value, date_format)
    except ValueError:
        try:
            original_date = datetime.strptime(value, "%Y")
        except ValueError:
            return value

    noise_days = int(random.uniform(-noise_factor, noise_factor) * 365)
    modified_date = original_date + timedelta(days=noise_days)
    return modified_date.strftime(date_format)

def add_noise_01(value, noise_factor=0.05):
    return round(max(0, min(value + random.uniform(-noise_factor, noise_factor), 1)), 3)

def process_data(data, noise_factor=0.05):
    processed_data = []
    for entry in data:
        processed_entry = {}
        for key, value in entry.items():
            if key == "popularity" or key == "duration_ms":
                processed_entry[key] = add_integer_noise(value)
            elif key == "release_date":
                processed_entry[key] = change_release_date(value, noise_factor)
            elif key in ["energy", "speechiness", "acousticness", "instrumentalness", "liveness", "valence"]:
                processed_entry[key] = add_noise_01(value, noise_factor)
            elif key in ["explicit", "mode", "time_signature"]:
                processed_entry[key] = value
            elif isinstance(value, float):
                processed_entry[key] = add_float_noise(value, noise_factor)
            else:
                processed_entry[key] = value
        processed_data.append(processed_entry)
    return processed_data

file_path = "data/new_tracks_with_genre.jsonl"
with open(file_path, "r") as file:
    json_lines = file.readlines()

data = [json.loads(line) for line in json_lines]
processed_data = process_data(data)

print("Oryginalne dane:")
print(data[0])

print("\nPrzetworzone dane:")
print(processed_data[0])

output_file_path = "microservice/tracks_with_genre_tests.jsonl"

with open(output_file_path, "w") as output_file:
    for entry in processed_data:
        json_line = json.dumps(entry, ensure_ascii=False)
        output_file.write(json_line + '\n')