Teacup::Stylesheet.new(:intro_sheet) do
  style :root,
    landscape: true

  style :page,
    backgroundColor: :clear.uicolor

  style :dismiss_button,
    height: 50, width: 50,
        center_x: '91%',
        center_y: '7%',
    tintColor: Theme::Base.color_theme[:tint],
    image: 'Delete Button - Line.png'.uiimage,
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)

  style :goaway_button,
    title: "Don't show this again",
    height: 50, width: 200,
    center_x: '45%', center_y: '72%'

  style :close_button,
    title: "Close",
    height: 50, width: 150,
    center_x: '45%', center_y: '78%'

  style :intro_label,
    backgroundColor: :clear.uicolor,
    textColor: Theme::Base.color_theme[:tint]

  style :title_label, extends: :intro_label,
    frame: [['5%', 0],['80%', '25%']],
    font: UIFont.fontWithName('Avenir-Heavy', size: 24.0),
    numberOfLines: 0

  style :body_label, extends: :intro_label,
    frame: [['5%', '25%'],['80%', '45%']],
    font: UIFont.fontWithName('Avenir-Light', size: 18.0),
    editable: false

  style :body_image,
    frame: [['15%', '20%'],['60%', '55%']],
    contentMode: UIViewContentModeScaleAspectFit,
    backgroundColor: :clear.uicolor
end