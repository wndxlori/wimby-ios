Teacup::Stylesheet.new(:intro_sheet) do
  style :root,
#    backgroundColor: Theme::Base.color_theme[:group_table_dark],
    landscape: true

  style :page,
    backgroundColor: Theme::Base.color_theme[:navbar_tint]

  style :dismiss_button,
    height: 50, width: 50,
        center_x: '90%',
        center_y: '6%',
    image: 'Checklist Icon.png'.uiimage,
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)

  style :goaway_button,
    tintColor: Theme::Base.color_theme[:tabbar_tint],
    title: "Don't show this again",
    height: 50, width: 200,
    center_x: '45%', center_y: '79%'

  style :close_button,
    tintColor: Theme::Base.color_theme[:tabbar_tint],
    title: "Close",
    height: 50, width: 150,
    center_x: '45%', center_y: '85%'

  style :intro_label,
    backgroundColor: Theme::Base.color_theme[:navbar_tint],
    textColor:  Theme::Base.color_theme[:navbar_text]

  style :title_page_label, extends: :intro_label,
    font: UIFont.fontWithName('Avenir-Black', size: 24.0)

  style :title_page_label2, extends: :intro_label,
    font: UIFont.fontWithName('Avenir-BlackOblique', size: 22.0)

  style :title_label, extends: :intro_label,
    frame: [['5%', 0],['80%', '25%']],
    font: UIFont.fontWithName('Avenir-Heavy', size: 24.0),
    numberOfLines: 0

  style :body_label, extends: :intro_label,
    frame: [['5%', '25%'],['80%', '75%']],
    textColor: Theme::Base.color_theme[:group_table_dark],
    font: UIFont.fontWithName('Avenir-Light', size: 18.0),
    editable: false

  style :body_image,
    frame: [['5%', '20%'],['80%', '55%']],
    contentMode: UIViewContentModeScaleAspectFit,
    backgroundColor: Theme::Base.color_theme[:navbar_tint]
end