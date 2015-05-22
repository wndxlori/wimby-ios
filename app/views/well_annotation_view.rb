class WellAnnotationView < MKAnnotationView
  def initWithAnnotation(annotation, reuseIdentifier:identifier)
    super(annotation, reuseIdentifier:identifier).tap do |view|
      view.image = UIImage.imageNamed('well_marker.png')
    end
  end
end
