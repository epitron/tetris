#######################################################################################################
# A little DSL for defining keyboard commands

class KeyMap

  attr_accessor :config

  #-----------------------------------------------------------------

  class Config

    NAMED_KEYS = {
      :up     => "\e[A",
      :down   => "\e[B",
      :right  => "\e[C",
      :left   => "\e[D",
      :home   => "\eOH",
      :end    => "\eOF",
      :pgup   => "\e[5~",
      :pgdown => "\e[6~",
    }

    attr_accessor :trie_root

    def initialize(&block)
      @trie_root = {}

      instance_eval(&block)

      # Make sure ^C is defined
      @trie_root["\C-c"] ||= { handler: proc { exit } }
    end

    #
    # Add a command to the trie of input sequences
    #
    def key(*seqs, &block)
      seqs.each do |seq|
        if keycode = NAMED_KEYS[seq]
          seq = keycode
        end

        level = @trie_root

        seq.each_char do |c|
          level = (level[c] ||= {})
        end

        level[:handler] = block
      end
    end

    #
    # This block will be run if the key isn't defined.
    #
    def default(&block)
      if block_given?
        @default = block
      else
        @default
      end
    end
  end

  #-----------------------------------------------------------------

  def initialize(&block)
    @config = Config.new(&block)
  end

  def process(input)
    level = config.trie_root

    # Read one character at a time from the input, and incrementally
    # walk through levels of the trie until a :handler is found, or
    # we hit a dead-end in the trie.
    loop do
      c = input.getc

      if found = level[c]
        level = found

        if handler = level[:handler]
          handler.call(c)
          level = config.trie_root
        end
      else
        config.default.call(c) if config.default
        level = config.trie_root
      end
    end
  end

end
