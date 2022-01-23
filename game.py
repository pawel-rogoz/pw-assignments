from database import load_from_csv
from player import Player
from pokemon import Pokemon
from random import sample

class NoPokemonsError(Exception):
    pass

class Game:
    def __init__(self, first_player:Player, second_player:Player):
        self._current_player = first_player
        self._against_player = second_player
        self._pokemons = self.select_random_pokemons('pokemons.csv', 20)
        self._pokemons_dict = {pokemon.name():pokemon for pokemon in self._pokemons}

    def pokemons(self):
        return self._pokemons

    def play(self):
        pokemons = self.pokemons()
        # pokemons_names = {pokemon.name():pokemon for pokemon in pokemons}

        print(f'Battle: {self.first_player.name()} vs {self.second_player.name()}')

        self.choose_pokemons(self._first_player)
        self.choose_pokemons(self._second_player)
        self.choose_pokemon(self._first_player)
        self.choose_pokemon(self._second_player)

        current = self.first_player()
        against = self.second_player()

        while current.has_alive_pokemons(): #czy current ma pokemony z hp>0
            self.round(current, against)
            temp = current
            current = against
            against = temp

    def choose_pokemon(self, player:Player):
        word = ''
        id = 1
        for pokemon in player.pokemons():
            word += f'\n{id}. {pokemon.name()}'
            id += 1
        choice = input("{player.name()}, select one of the pokemons:{word}")
        player.set_selected_pokemon(player.pokemons()[choice-1])

    def normal_attack(self, attacker:Player):
        pass

    def special_attack(self, player:Player):
        pass

    def change_pokemon(self, player):
        pass

    def choose_pokemons(self, player:Player):
        # while True:
        #     choice = input(f'{player.name()}, do you want to add pokemon? (y-yes or n-no)\n>>>')
        #     if choice == 'n':
        #         if len(player.pokemons()) != 0:  raise NoPokemonsError
        #         else: break
        #     if len(player.pokemons()) < 6:
        #         chosen = input(f'Choose pokemon from the list: ')
        #     else: break
        #wczytywać listę, a nie stringi w pętli
        pokemons_names = {} #pokemon.name():pokemon for pokemon in self.pokemons()}
        pokemons_numbers = {}
        number = 1
        for pokemon in self.pokemons():
            pokemons_names[pokemon.name()] = pokemon
            pokemons_numbers[number] = pokemon
            number += 1

        chosen = input(f'Choose your pokemons (1-6 pokemons) (divide them with", ")\n>>>')
        chosen.rsplit(', ')

        for pokemon in chosen:
            if pokemon in pokemons_names:
                player.add_pokemon(pokemons_names[pokemon])
            else:
                if pokemon in pokemons_numbers:
                    player.add_pokemon(pokemons_numbers[pokemon])
                else:
                    print('There is no pokemon like that. Try again')
                    player.remove_pokemons()
                    self.choose_pokemons(player)

    def round(self, player:Player, against_player:Player):
        player_choice = input("List of options:\n1. Defense\n2. Normal attack\n3.Special attack\n4. Change pokemon\n>>>")
        if player_choice == "1": player.selected_pokemon().increase_defence(10)
        elif player_choice == "2": against_player.selected_pokemon().decrease_hp(1)
        elif player_choice == "3": pass
        elif player_choice == "4": self.choose_pokemon(self._first_player)
        # match player_choice:
        #     case "1":
        #         player.selected_pokemon().increase_defence(10)
        #     case "2":
        #         #against player selected pokemon set hp cause of damage
        #         against_player.selected_pokemon().decrease_hp(1)
        #     case "3":
        #         pass
        #     case "4":
        #         self.choose_pokemon(self._first_player)

    def draw_pokemons(self, file):
        list_of_pokemons = load_from_csv(file)
        game_pokemons = sample(list_of_pokemons, 20)
        return game_pokemons

    def play(self):
        pokemons = self.pokemons()
        # pokemons_names = {pokemon.name():pokemon for pokemon in pokemons}

        print(f'Battle: {self.first_player.name()} vs {self.second_player.name()}')

        self.choose_pokemons(self._first_player)
        self.choose_pokemons(self._second_player)
        self.choose_pokemon(self._first_player)
        self.choose_pokemon(self._second_player)

        current = self.first_player()
        against = self.second_player()

        while current.has_alive_pokemons(): #czy current ma pokemony z hp>0
            self.round(current, against)
            temp = current
            current = against
            against = temp
