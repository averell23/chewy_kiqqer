require 'active_support/notifications'
require 'active_support/log_subscriber'

require "chewy_kiqqer/version"
require "chewy_kiqqer/mixin"
require "chewy_kiqqer/worker"
require "chewy_kiqqer/index"
require "chewy_kiqqer/logger"
require "chewy_kiqqer/log_subscriber"


ChewyKiqqer::LogSubscriber.attach_to 'chewy_kiqqer'
