import csv
from pokemon import Pokemon

def load_from_csv(file_handle):
    pokemons = []
    with open(file_handle, 'r', encoding="utf-8") as csvfile:
        reader = csv.reader(csvfile)
        header = next(csvfile)
        counter = 0
        for line in reader:
            list_of_abilities = []
            attributes = []
            for element in line:
                if '[' in element and ']' in element:
                    element = element.replace("'",'')
                    element = element.replace(' ','')
                    element = element.replace('[','')
                    element = element.replace(']','')
                    list_of_abilities.append(element)
                elif '[' in element:
                    counter = 1
                    element = element.replace("'",'')
                    element = element.replace(' ','')
                    element = element.replace('[','')
                    list_of_abilities.append(element)
                elif ']' in element:
                    element = element.replace(' ','')
                    element = element.replace("'",'')
                    counter = 0
                    element = element.replace(']','')
                    list_of_abilities.append(element)
                elif counter == 1:
                    element = element.replace("'",'')
                    element = element.replace(' ','')
                    list_of_abilities.append(element)
                elif counter == 0:
                    attributes.append(element)
            abilities = list_of_abilities
            against_normal = float(attributes[12])
            attack = int(attributes[18])
            defense = int(attributes[24])
            hp = int(attributes[27])
            name = str(attributes[29])
            sp_attack = int(attributes[32])
            sp_defense = int(attributes[33])
            pokemon = Pokemon(abilities, against_normal, attack, defense, hp, name, sp_attack, sp_defense)
            pokemons.append(pokemon)
    return pokemons
