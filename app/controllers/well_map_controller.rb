RegionChanged = "RegionChanged"
LocationEntered = "LocationEntered"
WellsLoaded = "WellsLoaded"

class WellMapController < UIViewController

  stylesheet :map_sheet

  attr_accessor :map,
                :saved_region

  def init
    super.tap do
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('Map', image:'map.png'.uiimage, tag:1)
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

  def preferredStatusBarStyle
    UIStatusBarStyleLightContent
  end

  layout :root do
    @map = subview(MKMapView, :map)
    @map.mapType = MKMapTypeStandard
    @map.delegate = self
    @map_cluster_controller = CCHMapClusterController.alloc.initWithMapView(@map)
    @map_cluster_controller.delegate = self
    @map_cluster_controller.reuseExistingClusterAnnotations = false

    @map.region = Location::CANADA_REGION
    self.navigationItem.rightBarButtonItem = create_track_button
    self.navigationItem.rightBarButtonItem.enabled = CLLocationManager.locationServicesEnabled
  end

  def create_track_button
    @button_on_img =  'tracking-on.png'.uiimage
    @button_img = 'tracking.png'.uiimage
    @track_button = UIBarButtonItem.alloc.initWithImage(
      @button_img,
      style: UIBarButtonItemStylePlain,
      target: self,
      action: 'track'
    )
  end

  def set_tracking(enabled)
    if enabled
      @map.showsUserLocation = true
      @track_button.image = @button_on_img
    else
      @map.showsUserLocation = false
      @track_button.image = @button_img
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
      add_callout_button(view, action: :show_details)
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
      "#{count} wells" : mapClusterAnnotation.annotations.allObjects.first.title
  end

  def mapClusterController(mapClusterController, subtitleForMapClusterAnnotation:mapClusterAnnotation)
    if mapClusterAnnotation.annotations.count > 1
      number_of_annotations = [mapClusterAnnotation.annotations.count, 3].min
      annotations = mapClusterAnnotation.annotations.allObjects[1..number_of_annotations]
      titles = annotations.map(&:title)
      titles.join(', ')
    end
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

  def show_details
    if @map.selectedAnnotations.size == 1
      well = @map.selectedAnnotations.first.annotations.allObjects.first
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
    if @did_show_details || @did_show_cluster
      @did_show_details = @did_show_cluster = false
      return
    end
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
      App.notification_center.post(RegionChanged, region_hash) unless region_hash['min_lat'].nan?
      mapView.removeAnnotations(mapView.annotations)
    end
  end

  def mapView(mapView, didUpdateUserLocation:location)
    mapView.setCenterCoordinate(location.location.coordinate, animated:true)
    region = MKCoordinateRegionMake(location.location.coordinate, MKCoordinateSpanMake(0.05,0.05))
    mapView.setRegion(region, animated:true)
  end

  # Show/hide the slidemenucontroller
  def show_menu(sender)
    self.navigationController.slideMenuController.toggleMenuAnimated(self)
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

  def load_wells(wells)
    WellStore.shared.context.performBlock -> {
      @map_cluster_controller.addAnnotations(wells, withCompletionHandler:nil)
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
end