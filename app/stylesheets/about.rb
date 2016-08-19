Teacup::Stylesheet.new(:about_sheet) do
  style :root,
    landscape: true

  style :text_view,
    font: UIFont.fontWithName('Avenir-Light', size: 15.0),
    editable: false,
    autoresizingMask: autoresize.fill,
    constraints: [
      :full_width,
      :full_height
    ]
end