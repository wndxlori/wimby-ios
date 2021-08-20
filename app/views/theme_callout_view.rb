class ThemeCalloutView < UIView

  INSET = UIEdgeInsetsMake(5,5,10,5)

  attr_accessor :annotation, :content_view

  # Need the annotation, so we can get the title/subtitle info to display in the callout
  def init(annotation)
    self.initWithFrame(CGRectZero).tap do
      self.annotation = annotation
      create_content_view
      configure_view
    end
  end

  # Wrapper view, because we know how this works with shape layers now, right?
  def create_content_view
    self.content_view = UIView.new.tap do |view|
      view.translatesAutoresizingMaskIntoConstraints = false
    end
  end

  def configure_view
    self.translatesAutoresizingMaskIntoConstraints = false

    self.addSubview(content_view)

    NSLayoutConstraint.activateConstraints([
        content_view.topAnchor.constraintEqualToAnchor(topAnchor, constant: INSET.top / 2.0),
        content_view.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -INSET.bottom),
        content_view.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: INSET.left / 2.0),
        content_view.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -INSET.right / 2.0),
        content_view.widthAnchor.constraintGreaterThanOrEqualToConstant(INSET.left + INSET.right),
        content_view.heightAnchor.constraintGreaterThanOrEqualToConstant(INSET.top + INSET.bottom),
    ])

    self.layer.insertSublayer(bubble_layer, atIndex: 0)
  end

  def bubble_layer
    @bubble_layer ||= CAShapeLayer.new.tap do |layer|
      layer.strokeColor = UIColor.clearColor.CGColor
      layer.fillColor = Theme::Base.color_theme[:cell_highlight_dark].CGColor
      layer.lineWidth = 0.5
    end
  end

  def layoutSubviews
    super
    update_path
  end

  def hitTest(point, withEvent: event)
    content_view_point = convertPoint(point, toView: content_view)
    content_view.hitTest(content_view_point, withEvent: event)
  end

  def add_to_annotation_view(annotation_view)
    annotation_view.addSubview(self)
    NSLayoutConstraint.activateConstraints([
        bottomAnchor.constraintEqualToAnchor(annotation_view.topAnchor, constant: annotation_view.calloutOffset.y),
        centerXAnchor.constraintEqualToAnchor(annotation_view.centerXAnchor, constant: annotation_view.calloutOffset.x)
    ])
  end

  private

  # Draws the actual bubble path
  def update_path
    path = UIBezierPath.new
    point = CGPointMake(bounds.size.width - INSET.right, bounds.size.height - INSET.bottom)

    path.moveToPoint(point)

    addStraightCalloutPointerToPath(path, angle: 0.25 * Math::PI)

    # bottom left
    point.x = INSET.left
    path.addLineToPoint(point)

    # lower left corner
    controlPoint = CGPointMake(0, bounds.size.height - INSET.bottom)
    point = CGPointMake(0, controlPoint.y - INSET.left)
    path.addQuadCurveToPoint(point, controlPoint: controlPoint)

    # left
    point.y = INSET.top
    path.addLineToPoint(point)

    # top left corner
    controlPoint = CGPointZero
    point = CGPointMake(INSET.left, 0)
    path.addQuadCurveToPoint(point, controlPoint: controlPoint)

    # top
    point = CGPointMake(bounds.size.width - INSET.left, 0)
    path.addLineToPoint(point)

    # top right corner
    controlPoint = CGPointMake(bounds.size.width, 0)
    point = CGPointMake(bounds.size.width, INSET.top)
    path.addQuadCurveToPoint(point, controlPoint: controlPoint)

    # right
    point = CGPointMake(bounds.size.width, bounds.size.height - INSET.bottom - INSET.right)
    path.addLineToPoint(point)

    # lower right corner
    controlPoint = CGPointMake(bounds.size.width, bounds.size.height - INSET.bottom)
    point = CGPointMake(bounds.size.width - INSET.right, bounds.size.height - INSET.bottom)
    path.addQuadCurveToPoint( point, controlPoint: controlPoint)

    path.closePath

    bubble_layer.path = path.CGPath
  end

  def addStraightCalloutPointerToPath(path, angle: angle)
    # lower right
    point = CGPointMake(bounds.size.width / 2.0 + Math::tan(angle) * INSET.bottom, bounds.size.height - INSET.bottom)
    path.addLineToPoint(point)

    # right side of pointer
    point = CGPointMake(bounds.size.width / 2.0, bounds.size.height)
    path.addLineToPoint(point)

    # left of pointer
    point = CGPointMake(bounds.size.width / 2.0 - Math::tan(angle) * INSET.bottom, bounds.size.height - INSET.bottom)
    path.addLineToPoint(point)
  end

end