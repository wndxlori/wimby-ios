RegionChanged = "RegionChanged"

class WellMapController < UIViewController
  include MapKit

  stylesheet :map_sheet

  attr_accessor :map

  def init
    super.tap do
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('Map', image:UIImage.imageNamed('map.png'), tag:1)
      navigationItem.title = 'Wells'
      navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage(
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
    region = CoordinateRegion.new(LocationCoordinate.new([62.4,-96.5]),CoordinateSpan.new([80.26-42.38,140.43-46.17]))
    @map.region = {region: region, animated: true}
#    load_wells
    track_button = MKUserTrackingBarButtonItem.alloc.initWithMapView(@map)
    track_button.target = self
    track_button.action = "track:"
    self.navigationItem.rightBarButtonItem = track_button
  end

  ViewIdentifier = 'WellIdentifier'
  def mapView(mapView, viewForAnnotation:annotation)
    return nil if annotation.is_a?(MKUserLocation) or annotation.is_a?(SPCluster)

    if view = mapView.dequeueReusableAnnotationViewWithIdentifier(ViewIdentifier)
      view.annotation = annotation
    else
      view = MKAnnotationView.alloc.initWithAnnotation(annotation, reuseIdentifier:ViewIdentifier)
      view.image = UIImage.imageNamed('well_marker.png')
      view.canShowCallout = true
      #view.animatesDrop = true
      button = UIButton.buttonWithType(UIButtonTypeDetailDisclosure)
      button.addTarget(self, action: :'showDetails:', forControlEvents:UIControlEventTouchUpInside)
      view.rightCalloutAccessoryView = button
    end
    view
  end

  def showDetails(sender)
    if @map.selectedAnnotations.size == 1
      well = @map.selectedAnnotations[0]
      controller = UIApplication.sharedApplication.delegate.well_details_controller
      controller.showDetailsForWell(well)
      navigationController.pushViewController(controller, animated:true)
    end
  end

  # Will update the region predicate for the Well Store, so that only visible wells will
  # be in the list, if/when we switch to the list view
  def mapView(mapView, regionDidChangeAnimated:animated)
    center = mapView.region.center
    span = mapView.region.span
    region_hash = {}
    region_hash['min_lat'] = center.latitude - (span.latitude_delta/2)
    region_hash['max_lat'] = center.latitude + (span.latitude_delta/2)
    region_hash['min_lng'] = center.longitude - (span.longitude_delta/2)
    region_hash['max_lng'] = center.longitude + (span.longitude_delta/2)
    NSLog("Map Region = #{region_hash}")
    App.notification_center.post(RegionChanged, region_hash) unless region_hash['min_lat'].nan?
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

  private

  def load_wells
    Dispatch::Queue.concurrent('com.wndx.wimby.task').async do
      @map.addAnnotations(WellStore.shared.wells)
    end
  end

end