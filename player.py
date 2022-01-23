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

