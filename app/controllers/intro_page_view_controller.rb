class IntroPageViewController < UIViewController
  stylesheet :intro_sheet
  layout :root

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

  def teacup_layout
    @title_label = subview UILabel, :title_label, text: NSString.stringWithFormat(self.title)
    if self.body
      @text_label = subview UITextView, :body_label, text: NSString.stringWithFormat(self.body)
    else
      @image_label = subview UIImageView, :body_image, image: self.body_image.uiimage
      if IntroDataSource.last_page(self.index)
        add_buttons
      end
    end
  end

  def add_buttons
    @goaway_button = subview UIButton.system, :goaway_button
    @goaway_button.on(:touch) do
      dismiss_modal
      App::Persistence['intro_dismissed'] = true
    end
    @close_button = subview UIButton.system, :close_button
    @close_button.on(:touch) do
      dismiss_modal
    end
  end
end