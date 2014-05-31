class CommonKey < ActiveRecord::Base
  def self.get(key)
    self.find_by(name: key)
  end

  def self.put(key, value)
    ks = self.find_or_create_by(name: key)
    ks.title = value
    ks.save!
    true
  end
end
