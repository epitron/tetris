##############################################################################################
require 'io/console'
##############################################################################################

def clear
  print "\e[H\e[J"
end

def clear_line
  print "\e[2K"
end

def clear_eol
  print "\e[0K"
end

def move_to(row=0, col=0)
  print "\e[#{row+1};#{col+1}H"
end

def move_to_row(n)
  move_to(n)
end

def move_to_top
  move_to_row(1)
end

def hide_cursor
  print "\e[?25l"
end

def show_cursor
  print "\e[?25h"
end

def newline
  print "\e[E"
end

def println(*what)
  print *what
  newline
end
