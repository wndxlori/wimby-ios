class AppDelegate

  attr_accessor :location

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    self.get_location

    menu = WimbyViewController.new
    tableview = WellTableViewController.alloc.init
    tablenav = WellNavController.alloc.initWithRootViewController(tableview)
    mapview = WellMapController.alloc.init
    mapnav = WellNavController.alloc.initWithRootViewController(mapview)

    tabbar = UITabBarController.alloc.init
    tabbar.viewControllers = [mapnav, tablenav]
    tabbar.selectedIndex = 1

#    UINavigationBar.appearance.titleTextAttributes = { UITextAttributeFont => 'Copperplate Bold'.uifont(20) }

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    root = NVSlideMenuController.alloc.initWithMenuViewController(menu, andContentViewController: tabbar)
    @window.rootViewController = root
    @window.makeKeyAndVisible
    true
  end


  def well_details_controller
    @well_details_controller ||= WellDetailsController.alloc.init
  end

  def get_location
    BubbleWrap::Location.get_once do |location|
      self.location = location
    end
  end
end