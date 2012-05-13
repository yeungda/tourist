class Tourist::Identifier
  ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
  def self.to_s_in_base(number, max)
    base = ALPHABET.length
    number = Integer(number)
    digits_required = self.log(max, base).floor
    (0..digits_required).to_a.inject("") {|s, index|
      ALPHABET[(number / (base ** index)) % base] + s
    }
  end
  def self.hash_with_identifier(total_size)
    index = 0
    Hash.new { 
      id = Tourist::Identifier.to_s_in_base(index, total_size)
      index = index + 1
      id
    }
  end

  private

  def self.log(numeric, base)
    (Math.log(numeric) / Math.log(base))
  end
end
