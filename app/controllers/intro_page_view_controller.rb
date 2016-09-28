class IntroPageViewController < UIViewController
  stylesheet :intro_sheet

  attr_accessor :index
  attr_accessor :title
  attr_accessor :body
  attr_accessor :body_image

  def initialize(page, index)
    self.index = index
    self.title = page[:title]
    self.body = page[:body]
    self.body_image = page[:body_image]
  end

  layout :root do
    @title_label = subview UILabel, :title_label, text: NSString.stringWithFormat(self.title)
    if self.body
      @text_label = subview UITextView, :body_label, text: NSString.stringWithFormat(self.body)
    else
      @image_label = subview UIImageView, :body_image, image: self.body_image.uiimage
    end
  end
end