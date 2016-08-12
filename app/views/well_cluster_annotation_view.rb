class WellClusterAnnotationView < MKAnnotationView

  attr_accessor :count
  attr_accessor :count_label

  def initWithAnnotation(annotation, reuseIdentifier:identifier)
    super.tap do |view|
      view.backgroundColor = UIColor.clearColor
      view.setup_label
      view.count = annotation.annotations.count
    end
  end
  
  def setup_label
    @count_label = UILabel.alloc.initWithFrame(bounds)
    @count_label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @count_label.textAlignment = NSTextAlignmentCenter
    @count_label.backgroundColor = UIColor.clearColor
    @count_label.textColor = Theme::Base.color_theme[:tint]
    @count_label.textAlignment = NSTextAlignmentCenter
    @count_label.adjustsFontSizeToFitWidth = true
    @count_label.minimumScaleFactor = 2
    @count_label.numberOfLines = 1
    @count_label.font = UIFont.boldSystemFontOfSize(10)
    @count_label.baselineAdjustment = UIBaselineAdjustmentAlignCenters

    addSubview(@count_label)
  end

  def count=(new_count)
    @count = new_count
    self.count_label.text = @count.to_s
    self.setNeedsLayout
  end

  # See https://github.com/choefele/CCHMapClusterController/blob/master/CCHMapClusterController%20Example%20iOS/CCHMapClusterController%20Example%20iOS/ClusterAnnotationView.m
  def layoutSubviews
    self.image = image_for_count
    self.count_label.frame = self.bounds
    self.centerOffset = CGPointZero
  end

  def image_for_count
    if (count > 10000)
      self.class.cluster(:xlarge)
    elsif (count > 1000)
      self.class.cluster(:large)
    elsif (count > 100)
      self.class.cluster(:medium)
    else
      self.class.cluster(:small)
    end
  end

  def self.cluster(size)
    base_color = Theme::Base.color_theme[:cell_highlight_dark]
    case size
      when :small
        @@small_cluster ||= WellClusterAnnotationView.colorCircle(base_color, 15)
      when :medium
        @@medium_cluster ||= WellClusterAnnotationView.colorCircle(base_color, 20)
      when :large
        @@large_cluster ||= WellClusterAnnotationView.colorCircle(base_color, 25)
      when :xlarge
        @@xlarge_cluster ||= WellClusterAnnotationView.colorCircle(base_color, 30)
    end
  end

  def self.colorCircle(color, radius)
    diameter = radius*2.0;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter,diameter), false, 0.0)
    ctx = UIGraphicsGetCurrentContext()
    CGContextSaveGState(ctx)

    rect = CGRectMake(0, 0, diameter, diameter)
    CGContextSetFillColorWithColor(ctx, color.colorWithAlphaComponent(0.4).CGColor)
    CGContextFillEllipseInRect(ctx, rect)
    inner_rect = CGRectMake(diameter*0.15, diameter*0.15, diameter*0.7, diameter*0.7)
    CGContextSetFillColorWithColor(ctx, color.colorWithAlphaComponent(0.7).CGColor)
    CGContextFillEllipseInRect(ctx, inner_rect)

    CGContextRestoreGState(ctx)
    circle = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    circle
  end
end
