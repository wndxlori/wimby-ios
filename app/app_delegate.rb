class AppDelegate

  attr_accessor :tab_bar_controller

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    menu = WimbyViewController.new
    tableview = WellTableViewController.alloc.init
    tablenav = UINavigationController.alloc.initWithRootViewController(tableview)
    mapview = WellMapController.alloc.init
    mapnav = UINavigationController.alloc.initWithRootViewController(mapview)

    self.tab_bar_controller = UITabBarController.alloc.init
    self.tab_bar_controller.viewControllers = [mapnav, tablenav]
    self.tab_bar_controller.selectedIndex = 0

#    UINavigationBar.appearance.titleTextAttributes = { UITextAttributeFont => 'Copperplate Bold'.uifont(20) }

    config = TSConfig.configWithDefaults();
    TSTapstream.createWithAccountName("wndxgroup", developerSecret:"SIeEgUZ-QaWg3nDdrAg88g", config:config)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    root = NVSlideMenuController.alloc.initWithMenuViewController(menu, andContentViewController: self.tab_bar_controller)
    @window.rootViewController = root
    @window.makeKeyAndVisible
    true
  end

  def well_details_controller
    @well_details_controller ||= WellDetailsController.alloc.init
  end

end