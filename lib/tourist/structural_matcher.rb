class Tourist::StructuralMatcher
  def self.match(expectation, actual)
    match = self.match?(expectation, actual)
    if match
      {:matches? => true}
    else
      {:matches? => false, :description => self.describe(expectation, actual)}
    end
  end

  private

  def self.match?(expectation, actual)
    if expectation == nil or actual == nil
      expectation == actual
    elsif expectation.class == Hash
      expectation.keys.map {|key|
        expectation_value = expectation[key]
        actual_value = actual[key]
        self.match?(expectation_value, actual_value)
      }.all? {|match| true == match}
    elsif expectation.class == Array
      (0..expectation.size-1).to_a.map {|index|
        self.match?(expectation[index], actual[index])
      }.all? {|match| true == match}
    elsif expectation.class == Regexp
      expectation.match(actual) != nil
    else
      expectation == actual
    end
  end

  def self.describe(expectation, actual, indentation=0)
    if expectation == nil
      ""
    elsif expectation.class == Hash
      pairs = expectation.keys.map {|key|
        indentation = indentation + 1
        expectation_value = expectation[key]
        actual_value = actual[key]
        if [Hash, Array].member? expectation_value.class
          "#{key.inspect} => " + self.describe(expectation_value, actual_value, indentation)
        else
          match = self.match?(expectation_value, actual_value)
          if match
            " #{key.inspect} => #{expectation_value.inspect}"
          else
            "-#{key.inspect} => #{expectation_value.inspect}" +
            if actual.has_key? key
              "\n+#{key.inspect} => #{actual_value.inspect}"
            else
              ""
            end
          end
        end
      }.join("\n  ")
      "{\n" + self.indent("#{pairs}", indentation) + "\n}"
    elsif expectation.class == Array
      items = (0..(expectation.size - 1)).to_a.map {|index|
        expected_item = expectation[index]
        actual_item = actual[index]
        self.describe(expected_item, actual_item)
      }.join("\n")
      "[\n#{indent(items, indentation)}\n]"
    elsif expectation.class == Regexp
      match = self.match?(expectation, actual)
      if match
        " #{expectation.inspect}"
      else
        "-#{expectation.inspect}\n+#{actual.inspect}"
      end
    else
      match = self.match?(expectation, actual)
      if match
        " #{expectation.inspect}"
      else
        "-#{expectation.inspect}\n+#{actual.inspect}"
      end
    end
  end

  def self.indent(s, indentation)
    spaces = ' ' * indentation
    spaces + s.gsub("\n", "\n#{spaces}")
  end
end
