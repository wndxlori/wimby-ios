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

  style :intro_label,
    backgroundColor: Theme::Base.color_theme[:navbar_tint],
    color:  Theme::Base.color_theme[:navbar_text]

  style :title_page_label, extends: :intro_label,
    font: UIFont.fontWithName('Avenir-Black', size: 24.0)

  style :title_page_label2, extends: :intro_label,
    font: UIFont.fontWithName('Avenir-BlackOblique', size: 22.0)

  style :title_label, extends: :intro_label,
    frame: [['5%', '5%'],['90%', '20%']],
    font: UIFont.fontWithName('Avenir-Heavy', size: 24.0),
    numberOfLines: 0

  style :body_label, extends: :intro_label,
    frame: [['5%', '25%'],['90%', '75%']],
    font: UIFont.fontWithName('Avenir-Light', size: 15.0),
    editable: false,
    autoresizingMask: autoresize.fill
end