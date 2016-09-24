class IntroPageViewController < UIViewController
  stylesheet :intro_sheet

  attr_accessor :index
  attr_accessor :title
  attr_accessor :text

  def initialize(page, index)
    self.index = index
    self.title = page[:title]
    self.text = page[:text]
  end

  layout :root do
    @title_label = subview UITextView, :title_label, text: self.title
    @text_label = subview UILabel, :text_label, self.text
  end
end