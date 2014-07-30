require 'logger'

module ChewyKiqqer

  def self.logger
    @logger
  end

  def self.logger=(value)
    @logger = value
  end

  # Locking scope for redis locks. Only necessary if
  # one redis instances locks more than one application
  def self.locking_scope=(value)
    @locking_scope = value
  end

  def self.locking_scope
    @locking_scope || 'default'
  end

end
