RegionChanged = "RegionChanged"
LocationEntered = "LocationEntered"
WellsLoaded = "WellsLoaded"

class WellMapController < UIViewController

  stylesheet :map_sheet

  attr_accessor :map,
                :saved_region

  def init
    super.tap do
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('Map', image:'Maps Icon - Inactive.png'.uiimage, selectedImage:'Maps Icon - Active.png'.uiimage)
      navigationItem.title = 'Well Map'
      navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage(
        'Search Icon - Inactive.png'.uiimage,
        style: UIBarButtonItemStylePlain,
        target: self,
        action: "show_menu:"
      )
      @last_update = Time.now
      @did_show_details = false
    end
  end

  def preferredStatusBarStyle
    UIStatusBarStyleLightContent
  end

  layout :root do
    @map = subview(MKMapView, :map)
    @map.mapType = MKMapTypeHybrid
    @map.delegate = self
    @map.region = Location::CANADA_REGION

    subview(create_map_type_button, :map_type_button)

    @map_cluster_controller = CCHMapClusterController.alloc.initWithMapView(@map)
    @map_cluster_controller.delegate = self
    @map_cluster_controller.reuseExistingClusterAnnotations = false

    self.navigationItem.rightBarButtonItem = create_track_button
    self.navigationItem.rightBarButtonItem.enabled = CLLocationManager.locationServicesEnabled

    create_activity_indicator
  end

  def create_track_button
    @button_on_img = 'Current Location Icon - Active.png'.uiimage
    @button_img = 'Current Location Icon - Inactive.png'.uiimage
    @track_button = UIBarButtonItem.alloc.initWithImage(
      @button_img,
      style: UIBarButtonItemStylePlain,
      target: self,
      action: 'track'
    )
  end

  def create_map_type_button
    @map_type_button = UIButton.buttonWithType(UIButtonTypeSystem).tap do |button|
      button.addTarget(self, action: 'map_type_action_sheet', forControlEvents: UIControlEventTouchUpInside)
    end
  end

  def create_activity_indicator
    @activity_indicator = UIActivityIndicatorView.large
    @activity_indicator.center = self.view.center
    subview(@activity_indicator)
  end

  def map_type_action_sheet
    map_type_action_sheet = UIAlertController.alert(self, {title: 'Change Map Type', buttons: %w(Roads Satellite), style: UIAlertControllerStyleActionSheet }) do |pressed|
      case pressed
        when 'Roads'
          @map.mapType = MKMapTypeStandard
        when 'Satellite'
          @map.mapType = MKMapTypeHybrid
      end
    end
    # This makes the UIAlertController "dark", without messing with any other appearance
    visualEffectView = map_type_action_sheet.view.findVisualEffectsSubview
    visualEffectView.effect = UIBlurEffect.effectWithStyle(UIBlurEffectStyleDark)
  end

  def set_tracking(enabled)
    if enabled
      UIApplication.sharedApplication.delegate.log_event('user-location')
      @map.showsUserLocation = true
      @track_button.image = @button_on_img
    else
      @map.showsUserLocation = false
      @track_button.image = @button_img
    end
    @user_location_updated = false
  end

  def track
    if @map.showsUserLocation
      location_manager.stopUpdatingLocation
      set_tracking(false)
    else
      if SimpleLocationManager.user_location_allowed?
        location_manager.startUpdatingLocation
        set_tracking(true) if location_manager.locationServicesEnabled
      else
        SimpleLocationManager.request_user_location(self)
      end
    end
  end

  def viewWillAppear(animated)
    add_observers unless @has_observers
  end

  def viewDidAppear(animated)
    center = @map.region.center
    span = @map.region.span
    region_hash = {}
    region_hash['min_lat'] = center.latitude - (span.latitudeDelta/2)
    region_hash['max_lat'] = center.latitude + (span.latitudeDelta/2)
    region_hash['min_lng'] = center.longitude - (span.longitudeDelta/2)
    region_hash['max_lng'] = center.longitude + (span.longitudeDelta/2)
    @activity_indicator.startAnimating
    App.notification_center.post(RegionChanged, region_hash)
    super
  end

  def viewWillDisappear(animated)
    remove_observers unless view_did_pop?
    super
  end

  def location_manager
    @location_manager ||= SimpleLocationManager.new.tap do |mgr|
      mgr.delegate = self
      mgr.requestWhenInUseAuthorization
    end
  end

  #### CLLocationManagerDelegate ####

  def locationManager(_, didChangeAuthorizationStatus: status)
    set_tracking(true) if status == KCLAuthorizationStatusAuthorizedWhenInUse
  end

  def locationmanager(_, didUpdateLocations: _)
    set_tracking(true)
  end

  def mapClusterController(mapClusterController, willReuseMapClusterAnnotation:mapClusterAnnotation)
    view = mapView(@map, viewForAnnotation:mapClusterAnnotation)
    if mapClusterAnnotation.isCluster
      view.count = mapClusterAnnotation.annotations.count
      view.rightCalloutAccessoryView.hidden = !mapClusterAnnotation.isUniqueLocation
    end
  end

  WellIdentifier = 'WellIdentifier'
  ClusterIdentifier = 'ClusterIdentifier'
  def mapView(mapView, viewForAnnotation:annotation)
    return nil unless annotation.is_a?(CCHMapClusterAnnotation)

    if annotation.isCluster
      unless view = mapView.dequeueReusableAnnotationViewWithIdentifier(ClusterIdentifier)
        view = WellClusterAnnotationView.alloc.initWithAnnotation(annotation, reuseIdentifier:ClusterIdentifier)
      end
      view.annotation = annotation
      view.count = annotation.annotations.count
      add_callout_button(view, action: :show_list)
    else
      unless view = mapView.dequeueReusableAnnotationViewWithIdentifier(WellIdentifier)
        view = WellAnnotationView.alloc.initWithAnnotation(annotation, reuseIdentifier:WellIdentifier)
      end
      view.annotation = annotation
#      add_callout_button(view, action: :show_details)
    end
    view.enabled = true
    view.canShowCallout = true
    view
  end

  def add_callout_button(view, action: callout_action)
    button = UIButton.buttonWithType(UIButtonTypeDetailDisclosure)
    button.addTarget(self, action: callout_action, forControlEvents: UIControlEventTouchUpInside)
    view.rightCalloutAccessoryView = button
  end

  def mapClusterController(mapClusterController, titleForMapClusterAnnotation:mapClusterAnnotation)
    count = mapClusterAnnotation.annotations.count
    count > 1 ?
      "#{count} wells" : WellBasic.new(mapClusterAnnotation.annotations.allObjects.first).title
  end

  def mapClusterController(mapClusterController, subtitleForMapClusterAnnotation:mapClusterAnnotation)
    return if mapClusterAnnotation.annotations.count > 1
    WellBasic.new(mapClusterAnnotation.annotations.allObjects.first).subtitle
  end

  def show_list
    if @map.selectedAnnotations.size == 1
      wells = @map.selectedAnnotations.first.annotations.allObjects
      controller = UIApplication.sharedApplication.delegate.cluster_table_view_controller
      controller.show_cluster(wells)
      @did_show_cluster = true
      navigationController.pushViewController(controller, animated:true)
    end
  end

  #
  # These will be part of the $$ version
  #
  # def show_details
  #   if @map.selectedAnnotations.size == 1
  #     well = @map.selectedAnnotations.first.annotations.allObjects.first
  #     controller = UIApplication.sharedApplication.delegate.well_details_controller
  #     controller.showDetailsForWell(well)
  #     @did_show_details = true
  #     navigationController.pushViewController(controller, animated:true)
  #   end
  # end

  # Will update the region predicate for the Well Store, so that only visible wells will
  # be in the list, if/when we switch to the list view
  def mapView(mapView, regionDidChangeAnimated:animated)
    return if not_so_fast
    if @did_show_details || @did_show_cluster
      @did_show_details = @did_show_cluster = false
      return
    end
    check_user_location
    center = mapView.region.center
    span = mapView.region.span
    region_hash = {}
    region_hash['min_lat'] = center.latitude - (span.latitudeDelta/2)
    region_hash['max_lat'] = center.latitude + (span.latitudeDelta/2)
    region_hash['min_lng'] = center.longitude - (span.longitudeDelta/2)
    region_hash['max_lng'] = center.longitude + (span.longitudeDelta/2)
    NSLog("Map Region = #{region_hash}")
    if did_region_hash_change?(region_hash)
      @last_update = Time.now
      @activity_indicator.startAnimating if slow_device?
      App.notification_center.post(RegionChanged, region_hash) unless region_hash['min_lat'].nan?
      mapView.removeAnnotations(mapView.annotations)
    end
  end

  def mapView(mapView, didUpdateUserLocation:location)
    unless @user_location_updated
      mapView.setCenterCoordinate(location.location.coordinate, animated:true)
      region = MKCoordinateRegionMake(location.location.coordinate, MKCoordinateSpanMake(0.05,0.05))
      mapView.setRegion(region, animated:true)
      @user_location_updated = location
    end
  end

  # Show/hide the slidemenucontroller
  def show_menu(sender)
    self.navigationController.slideMenuController.toggleMenuAnimated(self)
  end

  def load_wells(wells)
    WellStore.shared.context.performBlock -> {
      @map_cluster_controller.addAnnotations(wells, withCompletionHandler: ->{
        @activity_indicator.stopAnimating
      })
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
      region = MKCoordinateRegionMake(notification.object.coordinate, MKCoordinateSpanMake(0.15,0.15))
      @map.region = region
    end
    App.notification_center.observe WellsLoaded do |notification|
      self.load_wells(notification.object)
    end
  end

  def remove_observers
    App.notification_center.unobserve WellsLoaded
    App.notification_center.unobserve LocationEntered
    @has_observers = false
  end

  def slow_device?
    UIDevice.currentDevice.modelName.start_with?('iPhone 4', 'iPhone 5')
  end

  def check_user_location
    if @user_location_updated
      set_tracking(false) unless user_in_region?
    end
  end

  def user_in_region?
    userPoint = MKMapPointForCoordinate(@user_location_updated.location.coordinate)
    mapRect = @map.visibleMapRect
    MKMapRectContainsPoint(mapRect, userPoint)
  end
end