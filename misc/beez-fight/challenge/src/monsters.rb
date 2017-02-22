MONSTERS = [
  {
    :name => "Angry Dog",
    :weapons => [
      { :weapon_name => "Claws", :damage => 10..20 },
      { :weapon_name => "Teeth", :damage => 15..30 },
    ],
    :commonness => 30,
    :appears_in => [:alley, :forest],
    :health => (5..15),
  },
  {
    :name => "Archer, in rampage mode",
    :weapons => [
      { :weapon_name => "Gun", :damage => 50..75 },
      { :weapon_name => "Fists", :damage => 15..30 },
    ],
    :commonness => 10,
    :appears_in => [:alley, :cinema, :club],
    :health => (40..60),
  },
  {
    :name => "Some Dudebro",
    :weapons => [
      { :weapon_name => "His Face", :damage => 20..35 },
    ],
    :commonness => 10,
    :appears_in => [:club, :gym],
    :health => (10..20),
  },
  {
    :name => "Mafia Hitman",
    :weapons => [
      { :weapon_name => "Gun", :damage => 50..75 },
      { :weapon_name => "Garrot", :damage => 200..250 },
    ],
    :commonness => 1,
    :appears_in => [:alley, :street, :store],
    :health => (20..30),
  },
  {
    :name => "Dragon",
    :weapons => [
      { :weapon_name => "Claws", :damage => 50..75 },
      { :weapon_name => "Teeth", :damage => 50..150 },
      { :weapon_name => "Fire", :damage => 100..150 },
    ],
    :commonness => 3,
    :appears_in => [:forest],
    :health => (100..150),
  },
  {
    :name => "a ventriloquist and his puppet",
    :weapons => [
      { :weapon_name => "Hand (with puppet)", :damage => 5..10 },
      { :weapon_name => "Hand (without puppet)", :damage => 5..30 },
    ],
    :commonness => 10,
    :appears_in => [:cinema],
    :health => (10..15),
  },
  {
    :name => "Troll",
    :weapons => [
      { :weapon_name => "Claws", :damage => 30..50 },
      { :weapon_name => "Teeth", :damage => 35..50 },
      { :weapon_name => "Wild Rainbow Hair", :damage => 15..50 },
    ],
    :commonness => 5,
    :appears_in => [:forest],
    :health => (60..70),
  },
  {
    :name => "Goomba",
    :weapons => [
      { :weapon_name => "Touching", :damage => 10..20 },
      { :weapon_name => "Teeth", :damage => 15..30 },
    ],
    :commonness => 20,
    :appears_in => [:forest],
    :health => (2..5),
  },
  {
    :name => "Rabbit, but like a big one",
    :weapons => [
      { :weapon_name => "Claws", :damage => 10..20 },
      { :weapon_name => "Teeth", :damage => 15..30 },
    ],
    :commonness => 10,
    :appears_in => [:forest],
    :health => (20..30),
  },
  {
    :name => "The Beast",
    :weapons => [
      { :weapon_name => "Claws", :damage => 12..30 },
      { :weapon_name => "Teeth", :damage => 15..25 },
    ],
    :commonness => 3,
    :appears_in => [:forest],
    :health => (50..60),
  },
  {
    :name => "Taxi With Nothing To Lose",
    :weapons => [
      { :weapon_name => "Tires", :damage => 10..20 },
      { :weapon_name => "Tailpipe", :damage => 10..25 },
      { :weapon_name => "Door", :damage => 25..40 },
    ],
    :commonness => 5,
    :appears_in => [:street, :alley],
    :health => (50..60),
  },
  {
    :name => "Parashooters",
    :weapons => [
      { :weapon_name => "Parachuting", :damage => 10..20 },
      { :weapon_name => "Shooting", :damage => 15..30 },
    ],
    :commonness => 10,
    :appears_in => [:street],
    :health => (1..50),
  },
  {
    :name => "Lizardman in Human Form",
    :weapons => [
      { :weapon_name => "Claws", :damage => 10..20 },
      { :weapon_name => "Teeth", :damage => 15..30 },
      { :weapon_name => "Politics", :damage => 25..35 },
    ],
    :commonness => 5,
    :appears_in => [:street, :alley, :cinema, :club],
    :health => (5..20),
  },
  {
    :name => "Illumanati Agent",
    :weapons => [
      { :weapon_name => "Damaging Rumours", :damage => 5..30 },
    ],
    :commonness => 10,
    :appears_in => [:street, :alley, :cinema, :club],
    :health => (10..25),
  },
  {
    :name => "Talkshow Host",
    :weapons => [
      { :weapon_name => "Thrown Chair", :damage => 10..40 },
      { :weapon_name => "Rabid Audience", :damage => 15..50 },
    ],
    :commonness => 4,
    :appears_in => [:cinema],
    :health => (3..7),
  },
  {
    :name => "Vampire",
    :weapons => [
      { :weapon_name => "Claws", :damage => 25..35 },
      { :weapon_name => "Teeth", :damage => 35..67 },
    ],
    :commonness => 3,
    :appears_in => [:cinema],
    :health => (30..35),
  },
  {
    :name => "Hunter",
    :weapons => [
      { :weapon_name => "Gun", :damage => 10..20 },
    ],
    :commonness => 10,
    :appears_in => [:forest],
    :health => (5..20),
  },
  {
    :name => "Agent of Bram Stoker",
    :weapons => [
      { :weapon_name => "Book Deals", :damage => 1..2 },
    ],
    :commonness => 1,
    :appears_in => [:alley, :cinema],
    :health => (12..18),
  },
  {
    :name => "Talkshow Guest",
    :weapons => [
      { :weapon_name => "Claws", :damage => 14..20 },
      { :weapon_name => "Teeth", :damage => 18..28 },
      { :weapon_name => "Chair", :damage => 40..45 },
    ],
    :commonness => 5,
    :appears_in => [:cinema],
    :health => (1..5),
  },
  {
    :name => "Guy Using Phone In Movie Theatre",
    :weapons => [
      { :weapon_name => "Piercing Glare", :damage => 30..35 },
      { :weapon_name => "Thrown Phone", :damage => 15..30 },
    ],
    :commonness => 6,
    :appears_in => [:cinema],
    :health => (1..5),
  },
  {
    :name => "Yoshi's evil cousin (the %s one)" % ['red', 'green', 'orange'].sample,
    :weapons => [
      { :weapon_name => "Tongue", :damage => 5..10 },
    ],
    :commonness => 5,
    :appears_in => [:alley, :forest],
    :health => (5..10),
  },
  {
    :name => "Twins Who Only Kind of Look Alike",
    :weapons => [
      { :weapon_name => "The Left Twin (Or Maybe the Right)", :damage => 5..10 },
      { :weapon_name => "The Right Twin (Or Maybe the Left)", :damage => 5..10 },
    ],
    :commonness => 5,
    :appears_in => [:alley, :street, :cinema, :club, :gym],
    :health => (10..15),
  },
  {
    :name => "F-Society agent",
    :weapons => [
      { :weapon_name => "Hacking", :damage => 15..30 },
    ],
    :commonness => 2,
    :appears_in => [:alley, :store, :cinema, :club, :forest, :gym],
    :health => (15..20),
  },
  {
    :name => "E-Corp Agent",
    :weapons => [
      { :weapon_name => "Money", :damage => 15..30 },
    ],
    :commonness => 2,
    :appears_in => [:alley, :store, :cinema, :club, :forest, :gym],
    :health => (15..20),
  },
  {
    :name => "Bowser",
    :weapons => [
      { :weapon_name => "Claws", :damage => 10..20 },
      { :weapon_name => "Teeth", :damage => 15..30 },
      { :weapon_name => "Spikes", :damage => 25..30 },
    ],
    :commonness => 2,
    :appears_in => [:alley, :forest],
    :health => (70..80),
  },
  {
    :name => "Taupe Dragon",
    :weapons => [
      { :weapon_name => "Claws", :damage => 10..20 },
      { :weapon_name => "Teeth", :damage => 15..30 },
    ],
    :commonness => 3,
    :appears_in => [:forest],
    :health => (100..120),
  },
  {
    :name => "Doctor",
    :weapons => [
      # Note: If you change this, I suggest trying to make sure that the damage
      # is balanced, so on average the player won't lose anything
      { :weapon_name => "Painkillers", :damage => [-1] },
      { :weapon_name => "Medicine", :damage => [-2] },
      { :weapon_name => "Bedside Manner", :damage => 5..10 },
      { :weapon_name => "Medical bills", :damage => 10..15 },
    ],
    :commonness => 20,
    :appears_in => [:alley, :gym],
    :health => (5..10),
  },
]
