class Location
  attr_accessor :name
  CANADA_REGION = MKCoordinateRegionMake(CLLocationCoordinate2D.new(62.4,-96.5), MKCoordinateSpanMake(80.26-42.38,140.43-46.17))

  def initialize(lat, long, name)
    @name = name
    @coordinate = CLLocationCoordinate2DMake(lat, long)
  end

  def ==(other_location)
    self.name == other_location.name && self.coordinate == other_location.coordinate
  end

  def to_hash
    self.class.to_hash(self)
  end

  def self.initWithPlacemark(placemark)
    new(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude, placemark.name)
  end

  def self.initWithHash(loc_hash)
    new(loc_hash[:latitude], loc_hash[:longitude], loc_hash[:title])
  end

  def self.to_hash(location)
    {title: location.title, latitude: location.latitude, longitude: location.longitude }
  end

  def self.current_location=(location)
    App::Persistence['current_location'] = to_hash(location)
    add_to_previous(location) unless previous.include?(location) || Interesting.include?(location)
    App.notification_center.post(LocationEntered, location)
  end

  # This gets around frozen array issue in NSUserDefaults
  def self.add_to_previous(location)
    new_previous = previous.dup
    new_previous.unshift(location)
    self.previous = new_previous.slice(0..4)
  end

  def title; @name; end
  def coordinate; @coordinate; end
  def latitude; @coordinate.latitude; end
  def longitude; @coordinate.longitude; end

  def self.previous
    @@previous ||= App::Persistence['previous_locations'].nil? ?
      App::Persistence['previous_locations'] = [] :
      App::Persistence['previous_locations'].map {|loc| Location.initWithHash(loc)}
  end

  def self.previous=(new_previous)
    @@previous = new_previous
    App::Persistence['previous_locations'] = @@previous.map(&:to_hash)
  end

  Interesting =
    [
      Location.new(50.67390, -114.27886, 'Turner Valley AB'),
      Location.new(50.041069, -110.678093, 'Medicine Hat AB'),
      Location.new(49.39593, -103.41105, 'Midale SK')
    ]
end
