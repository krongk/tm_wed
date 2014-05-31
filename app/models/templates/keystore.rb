class Templates::Keystore < ActiveRecord::Base

  validates :source_type, :source_id, :key, :value, presence: true

  #soruce_obj in [Templates::Template, Templates::Page]
  def self.get(source_obj, key)
    return if source_obj.nil?
    self.find_by(source_type: source_obj.class.to_s, source_id: source_obj.id, key: key)
  end

  def self.put(source_obj, key, value)
    return if source_obj.nil?
    ks = self.find_or_create_by(source_type: source_obj.class.to_s, source_id: source_obj.id, key: key)
    ks.value = value
    ks.save!
    true
  end

  def self.value_for(source_obj, key)
    return if source_obj.nil?
    self.get(source_obj, key).try(:value)
  end

end
