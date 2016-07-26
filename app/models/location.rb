class Location
  attr_accessor :name

  def initialize(lat, long, name)
    @name = name
    @coordinate = CLLocationCoordinate2DMake(lat, long)
  end

  def self.initWithPlacemark(placemark)
    new(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude, placemark.name)
  end

  def title; @name; end
  def coordinate; @coordinate; end
  def latitude; @coordinate.latitude; end
  def longitude; @coordinate.longitude; end

#  Previous = [Location.new(54.4643,-110.1731,'Cold Lake, AB')]
 Previous = App::Persistence['previous_locations'].nil? ?
     App::Persistence['previous_locations'] = [] :
     App::Persistence['previous_locations']

  Interesting =
    [
      Location.new(50.67390, -114.27886, 'Turner Valley, AB'),
      Location.new(50.041069, -110.678093, 'Medicine Hat, AB'),
      Location.new(49.39593, -103.41105, 'Midale, SK')
    ]
end
