class Identifier
  ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
  def self.to_s_in_base(number, max)
    base = ALPHABET.length
    number = Integer(number)
    # digits_required = Math.log(max, base).floor for 1.9
    digits_required = (Math.log(max) / Math.log(base)).floor
    (0..digits_required).to_a.inject("") {|s, index|
      ALPHABET[(number / (base ** index)) % base] + s
    }
  end
  def self.hash_with_identifier(total_size)
    index = 0
    Hash.new { 
      id = Identifier.to_s_in_base(index, total_size)
      index = index + 1
      id
    }
  end
end
