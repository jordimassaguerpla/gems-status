class SecurityAlert
  attr_accessor :desc, :date
  def initialize(desc, date = nil)
    @desc = desc
    @date = date
  end
end
