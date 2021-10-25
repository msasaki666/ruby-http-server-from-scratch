# Rackアプリサンプル
class SampleApp
  class << self
    def call(env)
      [200, { "Content-Type" => "application/json" }, ['ok']]
    end
  end
end
