class Prediction
  attr_reader :diagnostic, :date

  def initialize diagnostic, date
    @diagnostic = diagnostic
    @date = date
  end
end