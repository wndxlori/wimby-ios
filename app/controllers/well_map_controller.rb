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

  layout :root do
    @map = subview(MKMapView, :map)
    @map.delegate = self
    @map_cluster_controller = CCHMapClusterController.alloc.initWithMapView(@map)
    @map_cluster_controller.delegate = self

    region = MKCoordinateRegionMake(CLLocationCoordinate2D.new(62.4,-96.5), MKCoordinateSpanMake(80.26-42.38,140.43-46.17))

    @map.region = region
    track_button = MKUserTrackingBarButtonItem.alloc.initWithMapView(@map)
    track_button.target = self
    track_button.action = "track:"
    self.navigationItem.rightBarButtonItem = track_button
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


  def mapClusterController(mapClusterController, willReuseMapClusterAnnotation:mapClusterAnnotation)
    view = mapView(@map, viewForAnnotation:mapClusterAnnotation)
    view.count = mapClusterAnnotation.annotations.count if mapClusterAnnotation.isCluster
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
      view.image = WellClusterAnnotationView.image_for_count(view.count)
      view.setNeedsDisplay
    else
      unless view = mapView.dequeueReusableAnnotationViewWithIdentifier(WellIdentifier)
        view = WellAnnotationView.alloc.initWithAnnotation(annotation, reuseIdentifier:WellIdentifier)
      end
      view.annotation = annotation
      button = UIButton.buttonWithType(UIButtonTypeDetailDisclosure)
      button.addTarget(self, action: :'show_details:', forControlEvents:UIControlEventTouchUpInside)
      view.rightCalloutAccessoryView = button
    end
    view.enabled = true
    view.canShowCallout = true
    view
  end

  def mapClusterController(mapClusterController, titleForMapClusterAnnotation:mapClusterAnnotation)
    count = mapClusterAnnotation.annotations.count
    count > 1 ?
      "#{count} wells" : mapClusterAnnotation.annotations.allObjects.first.title
  end

  def show_details(sender)
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
  # def mapView(mapView, regionDidChangeAnimated:animated)
  #   return if not_so_fast
  #   if @did_show_details
  #     @did_show_details = false
  #     return
  #   end
  #   center = mapView.region.center
  #   span = mapView.region.span
  #   region_hash = {}
  #   region_hash['min_lat'] = center.latitude - (span.latitudeDelta/2)
  #   region_hash['max_lat'] = center.latitude + (span.latitudeDelta/2)
  #   region_hash['min_lng'] = center.longitude - (span.longitudeDelta/2)
  #   region_hash['max_lng'] = center.longitude + (span.longitudeDelta/2)
  #   NSLog("Map Region = #{region_hash}")
  #   if did_region_hash_change?(region_hash)
  #     @last_update = Time.now
  #     App.notification_center.post(RegionChanged, region_hash) unless region_hash['min_lat'].nan?
  #     mapView.removeAnnotations(mapView.annotations)
  #   end
  # end

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
      self.load_wells(notification.object) unless App::Persistence['current_location'].nil?
    end
  end

  def remove_observers
    App.notification_center.unobserve WellsLoaded
    App.notification_center.unobserve LocationEntered
    @has_observers = false
  end


end