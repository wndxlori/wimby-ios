Teacup::Stylesheet.new(:map_sheet) do
  style :root,
    landscape: true,  # this must be on the root-view, to indicate that this view is
    gradient: {
      colors: ['#7a7a7a'.uicolor, '#414141'.uicolor]
    }

  style :map,
    autoresizingMask: autoresize.fill,
    constraints: [
      :full_width,
      :full_height
    ]

  style :map_type,
    height: 25, width: 200,
    center_x: '50%',
    top: '15%',  # includes an 8px margin from the bottom
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)
  style :map_type_button,
    height: 25, width: 25,
        center_x: '93%',
        center_y: '87%',
    image: 'Info Icon - Inactive.png'.uiimage,
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)
end