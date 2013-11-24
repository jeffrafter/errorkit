class Error < ActiveRecord::Base
  scope :unresolved, -> { where("resolved_at IS NULL") }

  def resolve!
    return true if self.resolved_at.present?

    self.update_attribute(:resolved_at, Time.now)
  end
end
