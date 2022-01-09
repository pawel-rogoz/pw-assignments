import csv
from pokemon import Pokemon

def load_from_csv(file_handle):
    pokemons = []
    with open(file_handle, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            abilities = row['abilities']
            against_bug = row['against_bug']
            against_dark = row['against_dark']
            against_dragon = row['against_dragon']
            against_electric = row['against_electric']
            against_fairy = row['against_fairy']
            against_fight = row['against_fight']
            against_fire = row['against_fire']
            against_flying = row['against_flying']
            against_ghost = row['against_ghost']
            against_grass = row['against_grass']
            against_ground = row['against_ground']
            against_ice = row['against_ice']
            against_normal = row['against_normal']
            against_poison = row['against_poison']
            against_psychic = row['against_psychic']
            against_rock = row['against_rock']
            against_steel = row['against_steel']
            against_water = row['against_water']
            attack = row['attack']
            base_egg_steps = row['base_egg_steps']
            base_happiness = row['base_happiness']
            base_total = row['base_total']
            capture_rate = row['capture_rate']
            classfication = row['classfication']
            defense = row['defense']
            experience_growth = row['experience_growth']
            height_m = row['height_m']
            hp = row['hp']
            japanese_name = row['japanese_name']
            name = row['name']
            percentage_male = row['percentage_male']
            pokedex_number = row['pokedex_number']
            sp_attack = row['sp_attack']
            sp_defense = row['sp_defense']
            speed = row['speed']
            type1 = row['type1']
            type2 = row['type2']
            weight_kg = row['weight_kg']
            generation = row['generation']
            is_legendary = row['is_legendary']
            #zamiast konstruktora zrobic settery
            pokemon = Pokemon(abilities, against_bug, against_dark, against_dragon, against_electric, against_fairy, against_fight,
                            against_fire, against_flying, against_ghost, against_grass, against_ground, against_ice, against_normal,
                            against_poison, against_psychic, against_rock, against_steel, against_water, attack, base_egg_steps,
                            base_happiness, base_total, capture_rate, classfication, defense, experience_growth, height_m, hp,
                            japanese_name, name, percentage_male, pokedex_number, sp_attack, sp_defense, speed, type1, type2, weight_kg,
                            generation, is_legendary)
            pokemons.append(pokemon)
    return pokemons
