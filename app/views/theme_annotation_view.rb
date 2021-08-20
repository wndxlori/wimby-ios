class ThemeAnnotationView < MKAnnotationView
  attr_accessor :callout_view

  def initWithAnnotation(annotation, reuseIdentifier:identifier)
    super(annotation, reuseIdentifier:identifier).tap do |view|
      view.canShowCallout = false
      view.animatesDrop = true
    end
  end

  def annotation=(new_annotation)
    super
    remove_callout
  end

  ANIMATION_DURATION = 0.25

  def setSelected(selected, animated: animated)
    super

    if selected
      remove_callout
      callout_view = WellCalloutView.alloc.init(annotation)
      callout_view.add_to_annotation_view(self)
      self.callout_view = callout_view

      if animated
        callout_view.alpha = 0
        UIView.animateWithDuration(ANIMATION_DURATION, animations: -> { callout_view.alpha = 1 })
      end
    else
      return unless callout_view = self.callout_view
      if animated
        UIView.animateWithDuration(ANIMATION_DURATION,
                                    animations: -> { callout_view.alpha = 0 },
                                    completion: -> _ { callout_view.removeFromSuperview})
      else
        remove_callout
      end
    end
  end

  def remove_callout
    self.callout_view.removeFromSuperview if self.callout_view
  end

  def prepareForReuse
    super
    remove_callout
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

end