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

    def has_alive_pokemons(self):
        for pokemon in self.pokemons():
            if pokemon.is_alive():
                return True
        return False

    def add_pokemon(self, pokemon:Pokemon):
        self._pokemons.append(pokemon)

    def set_main_pokemon(self, name):
        for pokemon in self._pokemons:
            if pokemon.name() == name:
                self._main_pokemon = pokemon
                return True
        return False

    def main_pokemon(self):
        return self._main_pokemon
