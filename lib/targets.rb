require File.dirname(__FILE__) + '/target.rb'

class Targets
  def initialize
    @dependencies = {}
  end

  def add(target)
    @dependencies[target.name] = target
  end

  def resolve(target_names)
    target_names = [target_names] unless target_names.respond_to? :each
    resolved = []
    target_names.map do |target_name|
      target = @dependencies[target_name]
      if not target.nil?
        resolved.push target
        resolved = (resolve(target.dependencies).flatten - resolved) + resolved
      end
    end
    resolved
  end
end
