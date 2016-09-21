class AboutViewController < UIViewController
  stylesheet :about_sheet

  def init
    super.tap do
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('About', image:'Info Icon - Inactive.png'.uiimage, selectedImage:'Info Icon - Active.png'.uiimage)
      navigationItem.title = 'About WIMBY'
      navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage(
        'Search Icon - Inactive.png'.uiimage,
        style: UIBarButtonItemStylePlain,
        target: self,
        action: "show_menu"
      )
      self.edgesForExtendedLayout = UIRectEdgeNone
    end
  end

  layout :root do
    @text_label = subview UITextView, :text_view, attributedText: about_text
    @text_label.delegate = self
  end

  def preferredStatusBarStyle
    UIStatusBarStyleLightContent
  end

  # Show/hide the slidemenucontroller
  def show_menu
    self.navigationController.slideMenuController.toggleMenuAnimated(self)
  end

  def about_text
    html = NSBundle.mainBundle.URLForResource('about', withExtension:'html')
    NSAttributedString.alloc.initWithFileURL(
        html,
        options:{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType},
        documentAttributes:nil,
        error:nil
    )
  end

  def textView(_, shouldInteractWithURL:_, inRange:_ )
    true
  end
end