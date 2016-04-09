class WellClusterAnnotationView < MKAnnotationView

  attr_accessor :count
  attr_accessor :count_label

  SMALL_CLUSTER  = UIImage.imageNamed("cluster32.png")
  MEDIUM_CLUSTER = UIImage.imageNamed("cluster40.png")
  LARGE_CLUSTER  = UIImage.imageNamed("cluster48.png")
  XLARGE_CLUSTER = UIImage.imageNamed("cluster56.png")

  def initWithAnnotation(annotation, reuseIdentifier:identifier)
    super.tap do |view|
#      self.setup_label
      self.count = annotation.annotations.count
      view.image = WellClusterAnnotationView.image_for_count(count)
    end
  end
  
  # def setup_label
  #   @count_label = UILabel.alloc.initWithFrame(bounds)
  #   @count_label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
  #   @count_label.textAlignment = NSTextAlignmentCenter
  #   @count_label.backgroundColor = UIColor.clearColor
  #   @count_label.textColor = UIColor.blueColor
  #   @count_label.textAlignment = NSTextAlignmentCenter
  #   @count_label.adjustsFontSizeToFitWidth = true
  #   @count_label.minimumScaleFactor = 2
  #   @count_label.numberOfLines = 1
  #   @count_label.font = UIFont.boldSystemFontOfSize(12)
  #   @count_label.baselineAdjustment = UIBaselineAdjustmentAlignCenters
  #
  #   addSubview(@count_label)
  # end

  # def drawRect(rect)
  #   super
  #   font = UIFont.boldSystemFontOfSize(12)
  #   UIColor.whiteColor.set
  #   text = count.to_s
  #   text.drawInRect(rect, withFont:font)
  # end

  def count=(new_count)
    @count = new_count
  end

  def self.image_for_count(count)
    if (count > 5000)
      XLARGE_CLUSTER
    elsif (count > 500)
      LARGE_CLUSTER
    elsif (count > 50)
      MEDIUM_CLUSTER
    else
      SMALL_CLUSTER
    end
  end
end
