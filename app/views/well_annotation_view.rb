class WellAnnotationView < MKAnnotationView

  attr_accessor :callout_view

  def initWithAnnotation(annotation, reuseIdentifier:identifier)
    super(annotation, reuseIdentifier:identifier).tap do |view|
      view.canShowCallout = false
      self.well = WellBasic.new(annotation.annotations.allObjects.first)
    end
  end

  def annotation=(new_annotation)
    super
    self.well = WellBasic.new(new_annotation.annotations.allObjects.first)
  end

  def set_well_image
    self.image = UIImage.imageNamed("well-marker-#{@well.color}.png")
    self.centerOffset = CGPointMake(0.0, -18)
  end

  AnimationDuration = 0.25

  def setSelected(selected, animated: animated)
    super

    if selected
      self.callout_view.removeFromSuperview if self.callout_view
      self.callout_view = UIView.alloc.initWithFrame(self.bounds).tap do |callout_view|
        callout_view.backgroundColor = UIColor.redColor
        self.addSubview(callout_view)
        self.bringSubviewToFront(callout_view)
      end

      if animated
        callout_view.alpha = 0
        UIView.animateWithDuration(0.25, animations: -> { callout_view.alpha = 1 })
      end
    else
      return unless callout_view = self.callout_view
      if animated
        UIView.animateWithDuration( 0.25,
                                    animations: -> { callout_view.alpha = 0 },
                                    completion: -> _ { callout_view.removeFromSuperview})
      else
        callout_view.removeFromSuperview
      end
    end
  end

  def prepareForReuse
    super
    self.callout_view.removeFromSuperview if self.callout_view
  end

  def hitTest(point, withEvent: event)
    hit_view = super
    return hit_view unless hit_view.nil?

    if callout_view = self.callout_view
      point_in_callout_view = convertPoint(point, toView: callout_view)
      return callout_view.hitTest(point_in_callout_view, withEvent: event)
    end

    return hit_view
   end

private

  def well=(new_well)
    @well = new_well
    set_well_image
  end

end
