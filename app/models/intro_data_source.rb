class IntroDataSource # UIPageViewControllerDataSource
  INTRO = [
      {title: 'WIMBY is', text: 'A collection of the abandoned oil & gas wells of Canada'},
      {title: 'What is an "abandoned well"', text: 'Well, it\'s not one of the orphaned wells you\'ve been hearing about.  Those tend to be viable (if currently uneconomic to produce) wells, which still have active mineral leases.' },
  ]
  attr_accessor :pages

  def initialize
    @pages = []
    @pages << IntroPageViewController.new(INTRO[0], 0)
  end

  def viewControllerAtIndex(index)
    return nil if index >= INTRO.length
    @pages[index] ||= IntroPageViewController.new(INTRO[index], index)
  end

  def indexOfViewController(viewController)
    viewController.index
  end

  def pageViewController(pageViewController, viewControllerBeforeViewController:viewController)
    index = viewController.index
    if index == 0
      return nil
    else
      index -= 1
    end
    self.viewControllerAtIndex(index)
  end

  def pageViewController(pageViewController, viewControllerAfterViewController:viewController)
    index = viewController.index
    if index == self.presentationCountForPageViewController(self)
      return nil
    else
      index += 1
    end
    self.viewControllerAtIndex(index)
  end

  def presentationCountForPageViewController(_)
    INTRO.length
  end

  def presentationIndexForPageViewController(_)
    0
  end
end