from database import load_from_csv
from player import Player
from pokemon import Pokemon
from random import sample
import os

class NoPokemonsError(Exception):
    pass

class Game:
    def __init__(self, first_player:Player, second_player:Player):
        self._current_player = first_player
        self._against_player = second_player
        self._pokemons = self.select_random_pokemons('pokemons.csv', 20)
        self._pokemons_dict = {pokemon.name():pokemon for pokemon in self._pokemons}

    def pokemons_dict(self):
        return self._pokemons_dict

    def pokemons(self):
        return self._pokemons

    def current_player(self):
        return self._current_player

    def against_player(self):
        return self._against_player

    def play(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f'Battle: {self.current_player().name()} vs {self.against_player().name()}\n')

        self.choose_pokemons(self._current_player)
        self.choose_pokemons(self._against_player)
        self.choose_pokemon(self._first_player)
        self.choose_pokemon(self._second_player)

        current = self.first_player()
        against = self.second_player()

        while self.current_player().has_alive_pokemons(): #czy current ma pokemony z hp>0
            self.round()
            self.select_new_pokemon_if_not_alive()
            self.swith_current_player()

    def swith_current_player(self):
        temp = self._current_player
        self._current_player = self._against_player
        self._against_player = temp

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

    def select_pokemons(self, player:Player):
        pokemons = self.pokemons_dict()
        print("List of pokemon(s):\n")
        print("NAME             HP      ATTACK      DEFENSE     SP_ATTACK       SP_DEFENSE      ABILITIES NUMBER")
        for name in pokemons:
            pokemon = pokemons[name]
            print(f'{pokemon.name()}'+' '*(17-len(str(pokemon.name())))+f'{pokemon.hp()}'+' '*(8-len(str(pokemon.hp())))+f'{pokemon.attack()}'+' '*(12-len(str(pokemon.attack())))+f'{pokemon.defense()}'+' '*(12-len(str(pokemon.defense())))+f'{pokemon.sp_attack()}'+' '*(16-len(str(pokemon.sp_attack())))+f'{pokemon.sp_defense()}'+' '*(16-len(str(pokemon.sp_defense())))+f'{len(pokemon.abilities())}')

        chosen = input(f'{player.name()}, choose your pokemons (1-6 pokemons) (divide them with ", ")\nFirst selected will be your main pokemon at least for the first round\n>>>')
        tab = chosen.rsplit(', ')

        for pokemon in tab:
            if pokemon in pokemons:
                if pokemons[pokemon] in player.pokemons():
                    print("You can't choose two same pokemons. Try again")
                    player.clear_pokemons()
                    self.trap()
                    self.select_pokemons(player)
                else:
                    player.add_pokemon(pokemons[pokemon])
            else:
                print(f'There is no pokemon with name: {pokemon}. Try again')
                self.trap()
                player.clear_pokemons()
                self.select_pokemons(player)
                break

        if len(tab) > 6:
            print('You choose more than 6 pokemons. Try again')
            player.clear_pokemons()
            self.trap()
            self.select_pokemons(player)

        main_pokemon = pokemons[tab[0]]
        player.set_main_pokemon(main_pokemon.name())
        print("Added succesfully")
        self.trap()

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
