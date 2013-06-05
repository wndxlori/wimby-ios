class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    menu = WimbyViewController.new
    tableview = WellTableViewController.alloc.init
    nav = WellNavController.alloc.initWithRootViewController(tableview)

    tabbar = UITabBarController.alloc.init
    tabbar.viewControllers = [WellMapController.alloc.init, nav]
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
end