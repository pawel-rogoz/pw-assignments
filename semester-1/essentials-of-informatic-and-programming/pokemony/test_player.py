from player import Player
from pokemon import Pokemon


def test_player_name():
    player = Player('Jan')
    assert player.name() == 'Jan'

def test_player_pokemons_default():
    player = Player('Jan')
    assert player.pokemons() == []

def test_player_pokemons():
    pokemon = Pokemon(['KeenEye'], 100, 100, 100, 100, 'Bulbasaur', 100, 100)
    player = Player('Jan', [pokemon])
    assert player.pokemons() == [pokemon]

def test_clear_pokemons():
    pokemon = Pokemon(['KeenEye'], 100, 100, 100, 100, 'Bulbasaur', 100, 100)
    player = Player('Jan', [pokemon])
    player.clear_pokemons()
    assert player.pokemons() == []

def test_has_alive_pokemons():
    pokemon = Pokemon(['KeenEye'], 100, 100, 100, 100, 'Bulbasaur', 100, 100)
    player = Player('Jan', [pokemon])
    assert player.has_alive_pokemons() == True
    pokemon.decrease_hp(100)
    assert player.has_alive_pokemons() == False

def test_remove_pokemon():
    pokemon1 = Pokemon(['KeenEye'], 100, 100, 100, 100, 'Bulbasaur', 100, 100)
    pokemon2 = Pokemon(['Light'], 100, 100, 100, 0, 'Mooko-o', 100, 100)
    player = Player('Jan', [pokemon1, pokemon2])
    player.remove_pokemon(pokemon2)
    assert player.pokemons() == [pokemon1]

def test_add_pokemon():
    pokemon1 = Pokemon(['KeenEye'], 100, 100, 100, 100, 'Bulbasaur', 100, 100)
    pokemon2 = Pokemon(['Light'], 100, 100, 100, 0, 'Mooko-o', 100, 100)
    player = Player('Jan', [pokemon1])
    player.add_pokemon(pokemon2)
    assert player.pokemons() == [pokemon1, pokemon2]

def test_set_main_pokemon():
    pokemon1 = Pokemon(['KeenEye'], 100, 100, 100, 100, 'Bulbasaur', 100, 100)
    pokemon2 = Pokemon(['Light'], 100, 100, 100, 0, 'Mooko-o', 100, 100)
    player = Player('Jan', [pokemon1, pokemon2])
    player.set_main_pokemon('Bulbasaur')
    assert player.main_pokemon() == pokemon1
