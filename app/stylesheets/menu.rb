Teacup::Stylesheet.new(:menu_sheet) do
  style :root,
    landscape: true,  # this must be on the root-view, to indicate that this view is
    gradient: {
      colors: ['#7a7a7a'.uicolor, '#414141'.uicolor]
    }
end