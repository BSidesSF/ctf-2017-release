WEAPONS = [
  {
    :type => :weapon,
    :name => "stick",
    :value => 1,
    :description => "It's a stick",
    :commonness => 100,

    :damage => 0..5,
  },
  {
    :type => :weapon,
    :name => "an umbrella",
    :value => 10,
    :description => "It's not very sharp!",
    :commonness => 70,

    :damage => 5..10,
  },
  {
    :type => :weapon,
    :name => "golf club",
    :value => 20,
    :description => "This looks like it'll swing pretty hard!",
    :commonness => 50,

    :damage => 10..20,
  },
  {
    :type => :weapon,
    :name => "chainsaw",
    :value => 30,
    :description => "Be careful!",
    :commonness => 30,

    :damage => 15..25,
  },
  {
    :type => :weapon,
    :name => "lawnmower",
    :value => 100,
    :description => "This probably won't make a very effective weapon",
    :commonness => 1,

    :damage => 1..1,
  }
]

SHIELDS = [
  {
    :type => :shield,
    :name => "grass shield",
    :value => 1,
    :description => "This doesn't even make sense",
    :commonness => 100,

    :defense => 0.1,
  },
  {
    :type => :shield,
    :name => "dinner plate",
    :value => 5,
    :description => "I hope I don't get attacked by something strong!",
    :commonness => 70,

    :defense => 0.2,
  },
  {
    :type => :shield,
    :name => "hubcap",
    :value => 10,
    :description => "I think this might block some attacks!",
    :commonness => 50,

    :defense => 0.3,
  },
  {
    :type => :shield,
    :name => "trashcan lid",
    :value => 25,
    :description => "Wow, this makes a pretty good shield!",
    :commonness => 30,

    :defense => 0.4,
  },
  {
    :type => :shield,
    :name => "fridge door",
    :value => 120,
    :description => "I can barely hold this up! How am I supposed to shield myself?",
    :commonness => 10,

    :defense => 0.5,
  }
]

POTIONS = [
  {
    :type => :potion,
    :name => "ginger ale",
    :value => 5,
    :description => "This smells pretty good",
    :commonness => 15,

    :healing => 1..5,
  },
  {
    :type => :potion,
    :name => "tea",
    :value => 10,
    :description => "I think it's probably hot Earl Grey tea. Not because of the smell, but because programmers love Captain Picard.",
    :commonness => 12,

    :healing => 3..8,
  },
  {
    :type => :potion,
    :name => "a colourful drink with a little umbrella",
    :value => 20,
    :description => "I'm not sure what it is, but it tastes like sugar!",
    :commonness => 8,

    :healing => 6..10,
  },
  {
    :type => :potion,
    :name => "chartreuse",
    :value => 40,
    :description => "It's clear, and green, and hurts my nose when I try to smell it!",
    :commonness => 4,

    :healing => -20..-10,
  },
]

TRADE_GOODS = [
  {
    :type => :trading_good,
    :name => "socks",
    :value => 1,
    :description => "Somebody's old socks",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "wool",
    :value => 5,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "copper",
    :value => 5,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "quilt",
    :value => 5,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "chessboard, missing two pawns and a queen",
    :value => 10,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "child's stuffed animal",
    :value => 3,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "gold",
    :value => 20,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "diamonds",
    :value => 30,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "a few partially charged AA batteries",
    :value => 3,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "mop bucket that seems to be sentient, but we aren't really sure",
    :value => 10,
    :description => "It just gives off that feeling of sentience, you know?",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "an old TV guide",
    :value => 5,
    :description => "The crosswords half done, in pen, with several mistakes. How hard is it to spell 'Oprah'?",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "half deflated basketball",
    :value => 5,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "jumble of coat hangers",
    :value => 10,
    :description => "Now I have a place to hang my jumble of coats!",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "the 's' key from a keyboard",
    :value => 5,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "airplane safety card and a Skymall(tm) magazine",
    :value => 10,
    :description => "It appears to be from a 747",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "an empty matchbook from a club you haven't heard of",
    :value => 3,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "backwards baseball cap",
    :value => 10,
    :description => "Wait, how did you know it's backwards?",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "seeds",
    :value => 20,
    :description => "I wonder what these will grow?",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "blueprints",
    :value => 1,
    :description => "For something called... 'The Death Star'?",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "pictures of cats",
    :value => 25,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "goop",
    :value => 1,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "takeout menu",
    :value => 10,
    :description => "It appears to be from a Thai Restaurant",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "vial of suspicious red fluid",
    :value => 20,
    :description => "Do you think it's blood?",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "domino",
    :value => 7,
    :description => "It's the piece the looks like |::|:.|",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "expired milk",
    :value => 1,
    :description => "",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "sandwich",
    :value => 5,
    :description => "Ham and cheese! That's my favourite!",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "small bowling ball",
    :value => 20,
    :description => "Ever heard of 5-pin bowling? It's all the rage in Canada!",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "one of those combined stop/slow signs that construction workers hold up",
    :value => 9,
    :description => ["It currently says 'stop'", "It currently says 'go'"].sample,
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "Zippo(tm) with no fluid left",
    :value => 5,
    :description => "Don't you hate how they're always empty?",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "bucket",
    :value => 5,
    :description => "It's full of... banana peels?",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "can of Slurm(tm)",
    :value => 10,
    :description => "It's addictive!",
    :commonness => 10,
  },
  {
    :type => :trading_good,
    :name => "fake mustache",
    :value => 5,
    :description => "But I already have a mustache!",
    :commonness => 10,
  },
]

FLAGS = [
  {
    :name => "flag.txt",
    :value => 31337,
    :description => "a little scrap of paper that reads 'FLAG:dfe85a56acba6b0149ce9c7526c7d42c'",
    :commonness => 0,
  },
]

ALL_ITEMS = WEAPONS + SHIELDS + POTIONS + TRADE_GOODS

def random_item(items)
  total = 0
  items.each do |item|
    total += item[:commonness]
  end

  item_num = rand(total)

  total = 0
  items.each do |item|
    total += item[:commonness]
    if(item_num < total)
      return item
    end
  end

  # This shouldn't really happy, but we'll return something just in case it does
  return {
    :name => '(nil)',
    :value => 0,
    :description => "Congratulations, you somehow got a no-item item! This shouldn't actually happen, so please ignore me and carry on. :)",
    :commonness => 0,
  }
end
