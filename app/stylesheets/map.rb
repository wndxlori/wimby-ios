Teacup::Stylesheet.new(:map_sheet) do
  style :root,
    landscape: true

  style :map,
    autoresizingMask: autoresize.fill,
    constraints: [
      :full_width,
      :full_height
    ]

  style :map_type_button,
    height: 28, width: 28,
        center_x: '91%',
        center_y: '86%',
    image: 'Settings Icon - Inactive.png'.uiimage,
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)
end