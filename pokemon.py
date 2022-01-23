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

    def against_bug(self):
      return self._against_bug

    def against_dark(self):
      return self._against_dark

    def against_dragon(self):
      return self._against_dragon

    def against_electric(self):
      return self._against_electric

    def against_fairy(self):
      return self._against_fairy

    def against_fight(self):
      return self._against_fight

    def against_fire(self):
      return self._against_fire

    def against_flying(self):
      return self._against_flying

    def against_ghost(self):
      return self._against_ghost

    def against_grass(self):
      return self._against_grass

    def against_ground(self):
      return self._against_ground

    def against_ice(self):
      return self._against_ice

    def against_normal(self):
      return self._against_normal

    def against_poison(self):
      return self._against_poison

    def against_psychic(self):
      return self._against_psychic

    def against_rock(self):
      return self._against_rock

    def against_steel(self):
      return self._against_steel

    def against_water(self):
      return self._against_water

    def attack(self):
      return self._attack

    def base_egg_steps(self):
      return self._base_egg_steps

    def base_happiness(self):
      return self._base_happiness

    def base_total(self):
      return self._base_total

    def capture_rate(self):
      return self._capture_rate

    def classfication(self):
      return self._classfication

    def defense(self):
      return self._defense

    def experience_growth(self):
      return self._experience_growth

    def height_m(self):
      return self._height_m

    def hp(self):
      return self._hp

    def japanese_name(self):
      return self._japanese_name

    def name(self):
      return self._name

    def percentage_male(self):
      return self._percentage_male

    def pokedex_number(self):
      return self._pokedex_number

    def sp_attack(self):
      return self._sp_attack

    def sp_defense(self):
      return self._sp_defense

    def speed(self):
      return self._speed

    def type1(self):
      return self._type1

    def type2(self):
      return self._type2

    def weight_kg(self):
      return self._weight_kg

    def generation(self):
      return self._generation

    def is_legendary(self):
      return self._is_legendary

    def increase_defence(self, percent):
      self._defense *= (1+percent/100)

    def decrease_hp(self, delta):
      self._hp -= delta

    def wczytaj(self):
      return False