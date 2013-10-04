Teacup::Stylesheet.new(:menu_sheet) do
  style :scroll_view,
    frame: [[0, '60%'],['85%', '40%']]

  style :table_view,
    scrollEnabled: false,
    width: '100%',
    height: '100%'
end