require File.dirname(__FILE__) + '/observer.rb'

class Observers
  def initialize(blackbox)
    @observers = {}
    @blackbox = blackbox
  end

  def add(observer)
    @observers[observer.location] = observer
  end

  def observe(location, browser)
    @observers[location].observe(browser, @blackbox) if @observers.has_key? location
  end
end
