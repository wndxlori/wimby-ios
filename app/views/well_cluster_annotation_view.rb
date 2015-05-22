class WellClusterAnnotationView < MKAnnotationView
  def initWithAnnotation(annotation, reuseIdentifier:identifier)
    super(annotation, reuseIdentifier:identifier).tap do |view|
      view.image = UIImage.imageNamed('cluster.png')
      setup_label
    end
  end
  
  def setup_label
    @count_label = UILabel.alloc.initWithFrame(bounds)
    @count_label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @count_label.textAlignment = NSTextAlignmentCenter
    @count_label.backgroundColor = UIColor.clearColor
    @count_label.textColor = UIColor.whiteColor
    @count_label.textAlignment = NSTextAlignmentCenter
    @count_label.adjustsFontSizeToFitWidth = true
    @count_label.minimumScaleFactor = 2
    @count_label.numberOfLines = 1
    @count_label.font = UIFont.boldSystemFontOfSize(12)
    @count_label.baselineAdjustment = UIBaselineAdjustmentAlignCenters
    
    addSubview(@count_label)
  end
  
  def count=(new_count)
    @count = new_count
    @count_label.text = @count.to_s
    setNeedsLayout
  end
end
