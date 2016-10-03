class IntroDataSource # UIPageViewControllerDataSource
  INTRO = [
      {title: 'WIMBY is', body: 'A collection of the abandoned oil & gas wells of Canada, on an easy to navigate map.'},
      {title: 'What is an "abandoned well"?', body: 'Well, it\'s not one of the orphaned wells you\'ve been hearing about. Those tend to be viable (if currently uneconomic to produce) wells, which still have active mineral leases.' },
      {title: 'So what IS an "abandoned well"?', body: 'It is a well no longer in use, whether dry, inoperable, or no longer economically viable. The well is plugged, surface features are removed, and the mineral lease is terminated.' },
      {title: 'Why does this matter?', body: "Once the surface features of the well are removed, one can no longer see that a well was ever present. Once the mineral lease ends, all references to the well fall off the surface land title, because there is no regulatory requirement to keep those references on the title.\n\nIn effect, those wells DISAPPEAR." },
      {title: 'Why should we care?', body: "Oil & Gas wells have been drilled in Canada since the early 1900's, but it wasn't until the 1960's that rules & regulations were codified and enforced around the process of abandonment. So, like Calmar AB discovered, you could have an abandoned well in your back yard and never know it."},
      {title: 'How can I tell when a well was abandoned?', body_image: 'legend.png'},
      {title: "EEK! What if I am sitting\non one of those wells?", body_image: 'keep-calm.png'},
  ]
  attr_accessor :pages

  def self.last_page(index)
    index == INTRO.length - 1
  end

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