# Wrapper provides basic well info in the interface. Complete WellInfo will be $$
class WellBasic
  def initialize(well)
    @well = well
  end
  def title; @well.uwi_display; end
  def subtitle; "Abandoned: #{@well.status_date.strftime('%Y-%m-%d')}"; end
  def coordinate; @well.coordinate; end

  def color; @well.color; end
end