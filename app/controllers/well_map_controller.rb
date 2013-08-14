class WellMapController < UIViewController
  include MapKit

  stylesheet :map_sheet

  attr_accessor :map

  MAP_QUERY_NAME   = 'QueryByMapRegion'
  MAP_QUERY_FORMAT = "(latitude > $min_lat AND latitude < $max_lat) AND (longitude > $min_lng AND longitude < $max_lng)"

  def init
    WellStore.shared.set_fetch_request_template(NSPredicate.predicateWithFormat(MAP_QUERY_FORMAT), forName:MAP_QUERY_NAME)
    super.tap do
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('Map', image:UIImage.imageNamed('map.png'), tag:1)
      self.navigationItem.title = 'Wells near ...'
      self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage(
        'menuicon.png'.uiimage,
        style: UIBarButtonItemStylePlain,
        target: self,
        action: "show_menu:"
      )
    end
  end

  layout :root do
    @map = subview(MapView, :map)
    @map.delegate = self
    region = CoordinateRegion.new(LocationCoordinate.new([62.4,-96.5]),CoordinateSpan.new([25.0,25.0]))
    @map.region = {region: region, animated: true}
    track_button = MKUserTrackingBarButtonItem.alloc.initWithMapView(@map)
    track_button.target = self
    track_button.action = "track:"
    self.navigationItem.rightBarButtonItem = track_button
  end

  ViewIdentifier = 'WellIdentifier'
  def mapView(mapView, viewForAnnotation:well)
    return nil if well.instance_of?(MKUserLocation)

    if view = mapView.dequeueReusableAnnotationViewWithIdentifier(ViewIdentifier)
      view.annotation = well
    else
      view = MKAnnotationView.alloc.initWithAnnotation(well, reuseIdentifier:ViewIdentifier)
      view.image = UIImage.imageNamed('well_marker.png')
      #view.canShowCallout = true
      #view.animatesDrop = true
      #button = UIButton.buttonWithType(UIButtonTypeDetailDisclosure)
      #button.addTarget(self, action: :'showDetails:', forControlEvents:UIControlEventTouchUpInside)
      #view.rightCalloutAccessoryView = button
    end
    view
  end
#
#  def showDetails(sender)
#    if view.selectedAnnotations.size == 1
#      well = view.selectedAnnotations[0]
#      controller = UIApplication.sharedApplication.delegate.well_details_controller
#      navigationController.pushViewController(controller, animated:true)
#      controller.showDetailsForBeer(well)
#    end
#  end

  def mapView(mapView, regionDidChangeAnimated:animated)
    return unless mapView.shows_user_location?
    center = mapView.region.center
    span = mapView.region.span
    region_hash = {}
    region_hash['min_lat'] = center.latitude - (span.latitude_delta/2)
    region_hash['max_lat'] = center.latitude + (span.latitude_delta/2)
    region_hash['min_lng'] = center.longitude - (span.longitude_delta/2)
    region_hash['max_lng'] = center.longitude + (span.longitude_delta/2)
    NSLog("Map Region = #{region_hash}")
    store = WellStore.shared
    request = store.fetch_request_template(region_hash, forName:MAP_QUERY_NAME)
    @map.addAnnotations(store.fetch(request))
  end

  # Show/hide the slidemenucontroller
  def show_menu(sender)
    self.navigationController.slideMenuController.toggleMenuAnimated(self)
  end

  # Enable/disable user tracking
  def track(sender)
    @map.shows_user_location = !@map.shows_user_location?
    @map.userTrackingMode = @map.userTrackingMode == MKUserTrackingModeNone ? MKUserTrackingModeFollow : MKUserTrackingModeNone
  end

end