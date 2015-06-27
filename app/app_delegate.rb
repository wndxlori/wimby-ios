class AppDelegate

  attr_accessor :tab_bar_controller, :slide_menu_controller

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

    setup_tapstream

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.slide_menu_controller = NVSlideMenuController.alloc.initWithMenuViewController(menu, andContentViewController: tab_bar_controller)
    @window.rootViewController = self.slide_menu_controller
    @window.makeKeyAndVisible
    initialize_datastore
    true
  end

  def well_details_controller
    @well_details_controller ||= begin
      controller =  WellDetailsController.alloc.initWithStyle(UITableViewStyleGrouped)
      controller.hidesBottomBarWhenPushed = true
      controller
    end
  end

private

  def initialize_datastore
    WellStore.shared
  end

  def setup_tapstream
    config = TSConfig.configWithDefaults();
    TSTapstream.createWithAccountName("wndxgroup", developerSecret:"SIeEgUZ-QaWg3nDdrAg88g", config:config)
  end

end