Teacup::Stylesheet.new(:menu_sheet) do
  style :container,
    frame: [[0,0], ['85%', '25%']]

  style :input_field,
    textAlignment: UITextAlignmentCenter,
    autocapitalizationType: UITextAutocapitalizationTypeWords,
    borderStyle: UITextBorderStyleRoundedRect

  style :location_input, extends: :input_field,
    placeholder: 'enter location',
    frame: [[5, 15], ['95%', 35]],
    returnKeyType: UIReturnKeyDone

  style :scroll_view,
    frame: [[0, '20%'],['85%', '75%']]

  style :table_view,
    scrollEnabled: false,
    width: '100%',
    height: '100%'
end