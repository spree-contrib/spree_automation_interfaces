module SpreeAutomationInterfaces
  VERSION = '1.0.0.alpha'.freeze

  module_function

  # Returns the version of the currently loaded SpreeAutomationInterfaces as a
  # <tt>Gem::Version</tt>.
  def version
    Gem::Version.new VERSION
  end
end
