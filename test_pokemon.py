from pokemon import Pokemon

def test_increase_defense():
    pokemon = Pokemon(['KeenEye'], 100, 100, 100, 100, 'Bulbasaur', 100, 100)
    pokemon.increase_defense(10)
    assert pokemon.defense() == 110

def test_decrease_hp():
    pokemon = Pokemon(['KeenEye'], 100, 100, 100, 100, 'Bulbasaur', 100, 100)
    pokemon.decrease_hp(100)
    assert pokemon.hp() == 0

def test_decrease_more_than_hp():
    pokemon = Pokemon(['KeenEye'], 100, 100, 100, 100, 'Bulbasaur', 100, 100)
    pokemon.decrease_hp(200)
    assert pokemon.hp() == 0

def test_is_alive():
    pokemon1 = Pokemon(['KeenEye'], 100, 100, 100, 100, 'Bulbasaur', 100, 100)
    pokemon2 = Pokemon(['Light'], 100, 100, 100, 0, 'Mooko-o', 100, 100)
    assert pokemon1.is_alive() == True
    assert pokemon2.is_alive() == False

def test_delete_ability():
    pokemon = Pokemon(['KeenEye'], 100, 100, 100, 100, 'Bulbasaur', 100, 100)
    assert len(pokemon.abilities()) == 1
    pokemon.delete_ability('KeenEye')
    assert len(pokemon.abilities()) == 0

def test_abilities():
    pokemon = Pokemon(['KeenEye'], 50, 30, 100, 70, 'Bulbasaur', 40, 80)
    assert len(pokemon.abilities()) == 1

def test_against_normal():
    pokemon = Pokemon(['KeenEye'], 50, 30, 100, 70, 'Bulbasaur', 40, 80)
    assert pokemon.against_normal() == 50

def test_attack():
    pokemon = Pokemon(['KeenEye'], 50, 30, 100, 70, 'Bulbasaur', 40, 80)
    assert pokemon.attack() == 30

def test_defense():
    pokemon = Pokemon(['KeenEye'], 50, 30, 100, 70, 'Bulbasaur', 40, 80)
    assert pokemon.defense() == 100

def test_hp():
    pokemon = Pokemon(['KeenEye'], 50, 30, 100, 70, 'Bulbasaur', 40, 80)
    assert pokemon.hp() == 70

def test_name():
    pokemon = Pokemon(['KeenEye'], 50, 30, 100, 70, 'Bulbasaur', 40, 80)
    assert pokemon.name() == 'Bulbasaur'

def test_sp_attack():
    pokemon = Pokemon(['KeenEye'], 50, 30, 100, 70, 'Bulbasaur', 40, 80)
    assert pokemon.sp_attack() == 40

def test_sp_defense():
    pokemon = Pokemon(['KeenEye'], 50, 30, 100, 70, 'Bulbasaur', 40, 80)
    assert pokemon.sp_defense() == 80

