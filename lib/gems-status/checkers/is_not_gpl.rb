module GemsStatus
  class IsNotGpl
    def initialize(conf)
    end
    def check?(gem)
      if !gem.license || gem.license.empty?
       return true
      end
      gem.license.upcase != "GPL"
    end
    def description
      "This gem is GPL"
    end
  end
end
