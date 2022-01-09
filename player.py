from pokemon import Pokemon

class Player:
    def __init__(self, name, pokemons):
        self._name = name
        self._pokemons = pokemons if pokemons else []

    def name(self):
        return self._name

    def pokemons(self):
        return self._pokemons

    def remove_pokemons(self):
        self._pokemons = []

    def has_alive_pokemons(self):
        for pokemon in self.pokemons():
            if pokemon.hp()>0:
                return True
        return False

    def add_pokemon(self, pokemon:Pokemon):
        self._pokemons.append(pokemon)

    def set_selected_pokemon(self, pokemon:Pokemon):
        self._selected_pokemon = pokemon

    def selected_pokemon(self):
        return self._selected_pokemon
