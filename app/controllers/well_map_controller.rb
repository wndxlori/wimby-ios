class WellMapController < UIViewController
  include MapKit

  stylesheet :map_sheet

  attr_accessor :map

  def init
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
    NSLog("Adding well at #{well.coordinate.latitude},#{well.coordinate.longitude}")
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
    center = mapView.region.center
    span = mapView.region.span
    min_lat, max_lat = center.latitude - (span.latitude_delta/2),center.latitude + (span.latitude_delta/2)
    min_lng, max_lng = center.longitude - (span.longitude_delta/2),center.longitude + (span.longitude_delta/2)
    NSLog("Map Region = #{min_lat},#{min_lng},#{max_lat},#{max_lng}")
    store = WellStore.shared
    @map.addAnnotations(store.fetch(store.predicateForCoordinates(min_lat,max_lat,min_lng,max_lng)))
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