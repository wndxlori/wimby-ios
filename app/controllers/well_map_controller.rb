class WellMapController < UIViewController
  include MapKit

  def init
    super.tap do
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('Map', image:UIImage.imageNamed('map.png'), tag:1)
    end
    #@position ||= UIApplication.sharedApplication.delegate.position
    #self
  end

  def loadView
    self.view = MKMapView.alloc.init
    view.delegate = self
  end

  def viewDidLoad
    view.frame = tabBarController.view.bounds

    #location = CLLocationCoordinate2D.new(@position.latitude,@position.longitude)
    # Center on Calgary.  51.0544° N, 114.0669° W
    map = MapView.new
    map.frame = self.view.frame
    map.delegate = self
    map.region = CoordinateRegion.new([51.05, -114.07], [3.1, 3.1])
    map.shows_user_location = true
    view.addSubview(map)
    #Beer::All.each { |beer| self.view.addAnnotation(beer) }
  end
#
#  def viewWillAppear(animated)
#    navigationController.setNavigationBarHidden(true, animated:true)
#  end
#
#  ViewIdentifier = 'ViewIdentifier'
#  def mapView(mapView, viewForAnnotation:beer)
#    if view = mapView.dequeueReusableAnnotationViewWithIdentifier(ViewIdentifier)
#      view.annotation = beer
#    else
#      view = MKAnnotationView.alloc.initWithAnnotation(beer, reuseIdentifier:ViewIdentifier)
#      view.image = UIImage.imageNamed('signpost.png')
#      view.canShowCallout = true
##      view.animatesDrop = true
#      button = UIButton.buttonWithType(UIButtonTypeDetailDisclosure)
#      button.addTarget(self, action: :'showDetails:', forControlEvents:UIControlEventTouchUpInside)
#      view.rightCalloutAccessoryView = button
#    end
#    view
#  end
#
#  def showDetails(sender)
#    if view.selectedAnnotations.size == 1
#      beer = view.selectedAnnotations[0]
#      controller = UIApplication.sharedApplication.delegate.beer_details_controller
#      navigationController.pushViewController(controller, animated:true)
#      controller.showDetailsForBeer(beer)
#    end
#  end
end