Teacup::Stylesheet.new(:menu_sheet) do
  style :scroll_view,
    frame: [[0, '3%'],['85%', '97%']],
    backgroundColor: :clear.uicolor

  style :table_view,
    scrollEnabled: false,
    width: '100%',
    height: '100%'
end