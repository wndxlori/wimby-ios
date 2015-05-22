class WellClusterAnnotationView < MKAnnotationView
  def initWithAnnotation(annotation, reuseIdentifier:identifier)
    super(annotation, reuseIdentifier:identifier).tap do |view|
      view.image = UIImage.imageNamed('cluster.png')
    end
  end
end
