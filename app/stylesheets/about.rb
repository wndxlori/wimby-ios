Teacup::Stylesheet.new(:about_sheet) do
  style :root,
    backgroundColor: UIColor.colorWithRed(0.25, green: 0.21, blue: 0.19, alpha: 1.00),
    landscape: true

  style :text_view,
    backgroundColor: UIColor.colorWithRed(0.25, green: 0.21, blue: 0.19, alpha: 1.00),
    dataDetectorTypes: UIDataDetectorTypeLink,
    font: UIFont.fontWithName('Avenir-Light', size: 15.0),
    editable: false,
    autoresizingMask: autoresize.fill,
    constraints: [
      constrain(:left).equals(:superview, :left).plus(10),
      constrain(:right).equals(:superview, :right).minus(10),
      constrain(:top).equals(:superview, :top),
      constrain(:bottom).equals(:superview, :bottom)
    ]
end