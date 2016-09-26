class IntroPageViewController < UIViewController
  stylesheet :intro_sheet

  attr_accessor :index
  attr_accessor :title
  attr_accessor :body

  def initialize(page, index)
    self.index = index
    self.title = page[:title]
    self.body = page[:body]
  end

  layout :root do
    @title_label = subview UILabel, :title_label, text: NSString.stringWithFormat(self.title)
    @text_label = subview UITextView, :body_label, text: self.body
  end
end