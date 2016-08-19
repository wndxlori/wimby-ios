Teacup::Stylesheet.new(:about_sheet) do
  style :root,
    landscape: true

  style :scroll_view,
    frame: [[0, 0],['100%', '100%']],
    autoresizingMask: autoresize.flexible_height,
    autoresizesSubviews: true,
    backgroundColor: UIColor.whiteColor

  style :text_view,
    constraints: [
      :full_width,
      :full_height
    ]
end