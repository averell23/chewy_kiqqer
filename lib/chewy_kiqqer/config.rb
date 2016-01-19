require 'logger'

module ChewyKiqqer

  mattr_accessor :logger

  # Locking scope for redis locks. Only necessary if
  # one redis instances locks more than one application

  mattr_accessor(:locking_scope) { 'default' }

end
