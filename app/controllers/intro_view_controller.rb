class IntroViewController < UIViewController
  stylesheet :intro_sheet

  attr_accessor :page_controller, :page_data

  layout :root do
    setup_page_controller

    subview(self.page_controller.view, :page, frame: UIEdgeInsetsInsetRect(self.view.frame, UIEdgeInsetsMake(20, 20, 20, 20)))
    @dismiss_button = subview(UIButton.custom, :dismiss_button).tap do |button|
#      button.tintColor = Theme::Base.color_theme[:tint]
      button.on(:touch) do
        dismiss_modal
      end
    end
    self.page_controller.didMoveToParentViewController(self)
    view.gestureRecognizers = self.page_controller.gestureRecognizers
  end

  def setup_page_controller
    self.page_controller = UIPageViewController.alloc.initWithTransitionStyle(UIPageViewControllerTransitionStyleScroll, navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal, options:nil)

    self.page_data = IntroDataSource.new
    self.page_controller.delegate = self.page_data
    self.page_controller.setViewControllers([self.page_data.viewControllerAtIndex(0)], direction:UIPageViewControllerNavigationDirectionForward, animated:false, completion:lambda{|_|})
    self.page_controller.dataSource = self.page_data
    addChildViewController(self.page_controller)
  end

end