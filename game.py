from database import load_from_csv
from player import Player
from pokemon import Pokemon
from random import sample
import os
import random

class NotEnoughPokemonsError(Exception):
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

    def calculate_damage(self, IsAttackSpecial:bool):
        offensive = self.current_player().main_pokemon()
        defensive = self.against_player().main_pokemon()
        """
        damage formula:     (3*Attack/Defence+2)*Modifier
        Attack  -> offensive.attack()  when attack is normal, offensive.sp_attack()  when it is special
        Defense -> defensive.defense() when attack is normal, defensive.sp_defense() when it is special
        Modifier formula:   type*random, in normal attack type is against_normal pokemon's attribute
        random -> random value from 0,85 to 1,00
        """
        randomize = random.randint(0,25)
        modifier = ((85 + randomize) * defensive.against_normal())/100

        if IsAttackSpecial:
            damage = int(((3*offensive.sp_attack())/defensive.sp_defense()+2) * modifier)
        else:
            damage = int(((3*offensive.attack())/defensive.defense()+2) * modifier)

        """
        If damage is more than pokemon's hp, method set it to hp points, cause minimum number of hp points is 0
        """
        damage = min(damage, defensive.hp())

        return damage

    def select_main_pokemon(self, player:Player):
        word = ''
        id = 1

        for pokemon in player.pokemons():
            word += f'\n{id}. {pokemon.name()}'
            id += 1

        choice = input(f'{player.name()}, select one of the pokemons by name:{word}\n>>>')

        changed = player.set_main_pokemon(choice)
        if changed:
            print("Chosen succesfully")
            self.trap()
        else:
            print("Wrong data. Try again")
            self.trap()
            self.select_main_pokemon(player)

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


    def select_random_pokemons(self, file, length):
        list_of_pokemons = load_from_csv(file)
        try:
            game_pokemons = sample(list_of_pokemons, length)
        except NotEnoughPokemonsError:
            print('Not enough pokemons in file to play game')
        return game_pokemons