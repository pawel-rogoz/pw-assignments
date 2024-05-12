from jsonOperations import *
import random

def joinTracksWithArtists(artistsDictionary, tracksDictionary):
    artists_mapping = {artist['id']: artist for artist in artistsDictionary}

    result_list = []
    for track in tracksDictionary:
        artist_id = track['id_artist']
        artist = artists_mapping.get(artist_id)

        if artist:
            genre = artist['genres']
            result_item = {
                # "id_artist": artist_id,
                "popularity": track['popularity'],
                "duration_ms": track['duration_ms'],
                "explicit": track['explicit'],
                "release_date": track['release_date'],
                "danceability": track['danceability'],
                "energy": track['energy'],
                "key": track['key'],
                "mode": track['mode'],
                "loudness": track['loudness'],
                "speechiness": track['speechiness'],
                "acousticness": track['acousticness'],
                "instrumentalness": track['instrumentalness'],
                "liveness": track['liveness'],
                "valence": track['valence'],
                "tempo": track['tempo'],
                "time_signature": track['time_signature'],
                "genres": genre
            }
            result_list.append(result_item)

    writeToNewJsonFile(result_list, 'data/tracks_with_genre.jsonl')

# idea of this function is to find the minimum representation number of tracks for some genre and to sample
# from other genres tracks to have exact same number of tracks for every genre
def tracksSampler(dictionary):
    converted_dictionary = genresDictionary(dictionary)
    min_occurance = min(len(lst) for lst in converted_dictionary.values())
    new_dict = sample(converted_dictionary, min_occurance*50)
    print(f"Minimum occurance: {min_occurance}")
    return new_dict

def genresDictionary(dictionary):
    new_dict = {}
    for track in dictionary:
        genre = track['genres'][0]
        if genre in new_dict:
            new_dict[genre].append(track)
        else:
            new_dict[genre] = []
    return new_dict

def sample(dictionary, number):
    result_list = []

    for key, values in dictionary.items():
        if len(values) >= number:
            sampled_elements = random.sample(values, number)
            result_list.extend(sampled_elements)
        else:
            result_list.extend(values.copy())

    return result_list
