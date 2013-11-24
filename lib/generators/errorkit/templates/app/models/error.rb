class Error < ActiveRecord::Base
  scope :unresolved, -> { where("resolved_at IS NULL") }

  def resolve!
    self.update_attribute(:resolved_at, Time.now)
  end
end
