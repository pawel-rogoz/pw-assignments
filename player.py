from pokemon import Pokemon

class Player:
    def __init__(self, name, pokemons):
        self._name = name
        self._pokemons = pokemons if pokemons else []

    def name(self):
        return self._name

    def pokemons(self):
        return self._pokemons

    def clear_pokemons(self):
        self._pokemons = []

    def remove_pokemon(self, pokemon):
        for element in self._pokemons:
            if element == pokemon:
                self._pokemons.remove(element)


