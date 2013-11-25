class Error < ActiveRecord::Base
  scope :unresolved, -> { where("resolved_at IS NULL") }

  def notify!
    return if Errorkit.config.notifier_recipients.blank? ||  Errorkit.config.notifier_sender.blank?

    # TODO, throttle
    Errorkit::ErrorsNotifier.error_notification(self.id).deliver
  end

  def resolve!
    return true if self.resolved_at.present?

    self.update_attribute(:resolved_at, Time.now)
  end
end
