class WellAnnotationView < MKAnnotationView

  def initWithAnnotation(annotation, reuseIdentifier:identifier)
    super(annotation, reuseIdentifier:identifier).tap do |view|
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

private

  def well=(new_well)
    @well = new_well
    set_well_image
  end

end
