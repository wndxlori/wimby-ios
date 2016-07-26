Teacup::Stylesheet.new(:menu_sheet) do
  style :scroll_view,
    frame: [[0, 0],['85%', '100%']]

  style :table_view,
    scrollEnabled: false,
    width: '100%',
    height: '100%'
end