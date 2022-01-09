class Pokemon:
    def __init__(self, abilities, against_bug, against_dark, against_dragon, against_electric, against_fairy, against_fight,
                against_fire, against_flying, against_ghost, against_grass, against_ground, against_ice, against_normal, against_poison,
                against_psychic, against_rock, against_steel, against_water, attack, base_egg_steps, base_happiness, base_total,
                capture_rate, classfication, defense, experience_growth, height_m, hp, japanese_name, name, percentage_male,
                pokedex_number, sp_attack, sp_defense, speed, type1, type2, weight_kg, generation, is_legendary):
        self._abilities = abilities
        self._against_bug = against_bug
        self._against_dark = against_dark
        self._against_dragon = against_dragon
        self._against_electric = against_electric
        self._against_fairy = against_fairy
        self._against_fight = against_fight
        self._against_fire = against_fire
        self._against_flying = against_flying
        self._against_ghost = against_ghost
        self._against_grass = against_grass
        self._against_ground = against_ground
        self._against_ice = against_ice
        self._against_normal = against_normal
        self._against_poison = against_poison
        self._against_psychic = against_psychic
        self._against_rock = against_rock
        self._against_steel = against_steel
        self._against_water = against_water
        self._attack = attack
        self._base_egg_steps = base_egg_steps
        self._base_happiness = base_happiness
        self._base_total = base_total
        self._capture_rate = capture_rate
        self._classfication = classfication
        self._defense = defense
        self._experience_growth = experience_growth
        self._height_m = height_m
        self._hp = hp
        self._japanese_name = japanese_name
        self._name = name
        self._percentage_male = percentage_male
        self._pokedex_number = pokedex_number
        self._sp_attack = sp_attack
        self._sp_defense = sp_defense
        self._speed = speed
        self._type1 = type1
        self._type2 = type2
        self._weight_kg = weight_kg
        self._generation = generation
        self._is_legendary = is_legendary

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
