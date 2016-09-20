Teacup::Stylesheet.new(:about_sheet) do
  style :root,
    landscape: true

  style :text_view,
    backgroundColor: UIColor.colorWithRed(0.25, green: 0.21, blue: 0.19, alpha: 1.00),
    font: UIFont.fontWithName('Avenir-Light', size: 15.0),
    editable: false,
    autoresizingMask: autoresize.fill,
    constraints: [
      :full_width,
      :full_height
    ]
end