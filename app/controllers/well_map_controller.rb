RegionChanged = "RegionChanged"
LocationEntered = "LocationEntered"
WellsLoaded = "WellsLoaded"

class WellMapController < UIViewController
  include MapKit

  stylesheet :map_sheet

  attr_accessor :map,
                :saved_region

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
      @last_update = Time.now
      @did_show_details = false
    end
  end

  layout :root do
    @map = subview(MapView, :map)
    @map.delegate = self
    region = CoordinateRegion.new(LocationCoordinate.new([62.4,-96.5]),CoordinateSpan.new([80.26-42.38,140.43-46.17]))
    @map.region = {region: region, animated: true}
    track_button = MKUserTrackingBarButtonItem.alloc.initWithMapView(@map)
    track_button.target = self
    track_button.action = "track:"
    self.navigationItem.rightBarButtonItem = track_button
  end

  def viewWillAppear(animated)
    add_observers unless @has_observers
  end

  def viewWillDisappear(animated)
    remove_observers unless view_did_pop?
    super
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
      @did_show_details = true
      navigationController.pushViewController(controller, animated:true)
    end
  end

  # Will update the region predicate for the Well Store, so that only visible wells will
  # be in the list, if/when we switch to the list view
  def mapView(mapView, regionDidChangeAnimated:animated)
    return if not_so_fast
    if @did_show_details
      @did_show_details = false
      return
    end
    center = mapView.region.center
    span = mapView.region.span
    region_hash = {}
    region_hash['min_lat'] = center.latitude - (span.latitude_delta/2)
    region_hash['max_lat'] = center.latitude + (span.latitude_delta/2)
    region_hash['min_lng'] = center.longitude - (span.longitude_delta/2)
    region_hash['max_lng'] = center.longitude + (span.longitude_delta/2)
    NSLog("Map Region = #{region_hash}")
    if did_region_hash_change?(region_hash)
      @last_update = Time.now
      App.notification_center.post(RegionChanged, region_hash) unless region_hash['min_lat'].nan?
    end
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

  def load_wells(wells)
    WellStore.shared.context.performBlock -> {
      @map.addAnnotations(wells)
    }
  end

  def did_region_hash_change?(region_hash)
    self.saved_region == region_hash ? false : self.saved_region = region_hash
  end

  def not_so_fast
    (Time.now - @last_update) < 1.0
  end

private

  def add_observers
    @has_observers = true
    App.notification_center.observe LocationEntered do |notification|
      region = CoordinateRegion.new(notification.object.coordinate, CoordinateSpan.new([0.15,0.15]) )
      @map.region = {region: region, animated: true}
    end
    App.notification_center.observe WellsLoaded do |notification|
      self.load_wells(notification.object) unless App::Persistence['current_location'].nil?
    end
  end

  def remove_observers
    App.notification_center.unobserve WellsLoaded
    App.notification_center.unobserve LocationEntered
    @has_observers = false
  end


end