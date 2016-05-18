class SimpleLocationManager < CLLocationManager
  def init
    super.tap do
      puts "Setting up location manager"
      desiredAccuracy = KCLLocationAccuracyThreeKilometers
      distanceFilter = 5000.0
      pausesLocationUpdatesAutomatically = true
      requestWhenInUseAuthorization
    end
  end

  def self.user_location_available?
    CLLocationManager.locationServicesEnabled &&
      SimpleLocationManager.location_request_allowed?
  end

  def self.location_request_allowed?
    true
  end
end