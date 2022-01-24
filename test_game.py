from player import Player
from game import Game


def test_current_player():
    player1 = Player('Jan')
    player2 = Player('Anna')
    game = Game(player1, player2)
    assert game.current_player() == player1

def test_against_player():
    player1 = Player('Jan')
    player2 = Player('Anna')
    game = Game(player1, player2)
    assert game.against_player() == player2

def test_switch_current_player():
    player1 = Player('Jan')
    player2 = Player('Anna')
    game = Game(player1, player2)
    assert game.current_player() == player1
    assert game.against_player() == player2
    game.swith_current_player()
    assert game.current_player() == player2
    assert game.against_player() == player1

