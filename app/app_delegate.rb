include SugarCube::Modal

class AppDelegate

  attr_accessor :tab_bar_controller, :slide_menu_controller

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    Theme::Base.apply(Theme::RUST, to_window: @window)

    menu = WimbyViewController.new
    tableview = WellTableViewController.alloc.init
    tablenav = UINavigationController.alloc.initWithRootViewController(tableview)
    mapview = WellMapController.alloc.init
    mapnav = UINavigationController.alloc.initWithRootViewController(mapview)
    aboutview = AboutViewController.alloc.init
    aboutnav = UINavigationController.alloc.initWithRootViewController(aboutview)

    self.tab_bar_controller = UITabBarController.alloc.init
    self.tab_bar_controller.viewControllers = [mapnav, tablenav, aboutnav]
    self.tab_bar_controller.selectedIndex = 0

    self.slide_menu_controller = NVSlideMenuController.alloc.initWithMenuViewController(menu, andContentViewController: tab_bar_controller)
    @window.rootViewController = self.slide_menu_controller
    @window.makeKeyAndVisible

    present_intro unless App::Persistence['intro_dismissed']

    initialize_datastore
    true
  end

  def well_details_controller
    @well_details_controller ||= WellDetailsController.alloc.initWithStyle(UITableViewStyleGrouped).tap do |controller|
      controller.hidesBottomBarWhenPushed = true
      controller
    end
  end

  def cluster_table_view_controller
    @cluster_table_view_controller ||= WellClusterTableViewController.alloc.initWithStyle(UITableViewStylePlain).tap do |controller|
      controller.hidesBottomBarWhenPushed = true
      controller
    end
  end

  def displayError(controller, message)
 	  alert = UIAlertController.alertControllerWithTitle("WIMBY is 😳",
                                    message:message,
                                    preferredStyle:UIAlertControllerStyleAlert)

     ok_action = UIAlertAction.actionWithTitle( "OK", style:UIAlertActionStyleDefault, handler: ->(_) {})
     alert.addAction(ok_action)
     controller.presentViewController(alert, animated:true, completion:nil)
 	end

  def present_intro
    self.tab_bar_controller.present_modal(IntroViewController.new)
  end

private

  def initialize_datastore
    WellStore.shared
  end

end