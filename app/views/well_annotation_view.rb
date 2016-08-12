class WellAnnotationView < MKAnnotationView

  attr_accessor :well

  def initWithAnnotation(annotation, reuseIdentifier:identifier)
    super(annotation, reuseIdentifier:identifier).tap do |view|
      self.well = annotation.annotations.allObjects.first
    end
  end

  def annotation=(new_annotation)
    super
    self.well = new_annotation.annotations.allObjects.first
  end

  def set_well_image
    case
      when self.well.status_date.year < 1960
        self.image = UIImage.imageNamed('well-marker-red.png')
      when self.well.status_date.year > 1969
        self.image = UIImage.imageNamed('well-marker-green.png')
      else
        self.image = UIImage.imageNamed('well-marker-yellow.png')
    end
    self.centerOffset = CGPointMake(0.0, -18)
  end

  def well=(new_well)
    @well = new_well
    set_well_image
  end

end
