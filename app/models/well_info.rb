class WellInfo < NSManagedObject

  def title; self.well_name; end
  def coordinate; @coordinate ||= CLLocationCoordinate2DMake(self.latitude, self.longitude); end

  # Available fields:
  # UWI_DISPLAY,UWI,UWI_SORT,WELL_NAME,CURRENT_STATUS,STATUS,STATUS_DATE,PLOT_SYMBOL,LATITUDE,LONGITUDE
  def self.attributes
    @attributes ||= [
      {:name => 'uwi_display', :type => NSStringAttributeType, :default => nil, :optional => false},
      {:name => 'well_name', :type => NSStringAttributeType, :default => nil, :optional => false},
      {:name => 'status', :type => NSStringAttributeType, :default => nil, :optional => false},
      {:name => 'status_date', :type => NSDateAttributeType, :default => nil, :optional => false},
      {:name => 'latitude', :type => NSFloatAttributeType, :default => 0, :optional => false},
      {:name => 'longitude', :type => NSFloatAttributeType, :default => 0, :optional => false},
    ]
  end

  def self.relationships
    @relationships ||= [
      {:name => 'details', :destination => 'WellDetails', :inverse => 'info', :optional => true, :transient => false, :indexed => false, :ordered => true, :min => 1, :max => 1, :del => NSCascadeDeleteRule},
    ]
  end

  def self.entity
    @entity ||= begin
      # Create the entity for our managed object class
      entity = NSEntityDescription.alloc.init
      entity.name = name
      entity.managedObjectClassName = name
      entity
    end
  end

end