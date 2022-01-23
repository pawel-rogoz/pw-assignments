class Pokemon:
    def __init__(self, abilities, against_normal, attack, defense, hp, name, sp_attack, sp_defense):
        self._abilities = abilities
        self._against_normal = against_normal
        self._attack = attack
        self._defense = defense
        self._hp = hp
        self._name = name
        self._sp_attack = sp_attack
        self._sp_defense = sp_defense

    def abilities(self):
      return self._abilities

    def against_normal(self):
      return self._against_normal

    def attack(self):
      return self._attack

    def defense(self):
      return self._defense

    def hp(self):
      return self._hp

    def name(self):
      return self._name

    def sp_attack(self):
      return self._sp_attack

    def sp_defense(self):
      return self._sp_defense

    def increase_defense(self, percent):
      self._defense = int(self._defense * (1+percent/100))

    def decrease_hp(self, delta):
      self._hp -= delta

    def is_alive(self):
      return self.hp() > 0

