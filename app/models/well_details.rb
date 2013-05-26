class WellDetails < NSManagedObject

  # Available fields:
  # UWI_DISPLAY,UWI,UWI_SORT,WELL_NAME,CURRENT_STATUS,STATUS,STATUS_DATE,PLOT_SYMBOL,LATITUDE,LONGITUDE
  def self.attributes
    @attributes ||= [
      {:name => 'uwi', :type => NSStringAttributeType, :default => nil, :optional => false},
      {:name => 'uwi_sort', :type => NSStringAttributeType, :default => nil, :optional => false},
      {:name => 'plot_symbol', :type => NSInteger32AttributeType, :default => 0, :optional => false},
      {:name => 'current_status', :type => NSStringAttributeType, :default => nil, :optional => false},
    ]
  end

  def self.relationships
    @relationships ||= [
      {:name => 'info', :destination => 'WellInfo', :inverse => 'details', :optional => true, :transient => false, :indexed => false, :ordered => true, :min => 1, :max => 1, :del => NSCascadeDeleteRule},
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