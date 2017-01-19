##############################################################################################
require 'epitools'
require_relative 'lib/game'
##############################################################################################

game = Game.new
game.keymap do
  key(:left)  { game.left! }
  key(:right) { game.right! }

  key('z', 'a')        { game.rotate!(-1) } # rotate left
  key('x', 's', :up)   { game.rotate!( 1) } # rotate right

  key(:down) { game.drop_now! }
  key(" ")   { game.drop_all_the_way! }

  key("q", "Q", "\C-c") { game.quit! }

  default { |c| puts " Unknown command: #{c}" }
end

game.play!