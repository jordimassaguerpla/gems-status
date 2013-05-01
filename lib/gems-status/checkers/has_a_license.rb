module GemsStatus
  class HasALicense
    def initialize(conf)
    end
    def check?(gem)
      gem.license && !gem.license.empty?
    end
    def description
      "This gem has not license"
    end
  end
end
