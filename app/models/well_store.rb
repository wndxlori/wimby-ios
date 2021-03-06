class WellStore

  attr_reader :context
  attr_accessor :wells

  def self.shared
    Dispatch.once do
      @instance ||= new
      App.notification_center.observe RegionChanged do |notification|
        @instance.fetchForCoordinates(notification.object)
      end
    end
    @instance
  end

  def fetchForCoordinates(region_hash)
    new_predicate = @predicate.predicateWithSubstitutionVariables(region_hash)
    NSLog("performing fetch with new predicate #{new_predicate.predicateFormat}")

    @context.performBlock -> {
      error_ptr = Pointer.new(:object)
      @fetch_request.predicate = new_predicate
      if self.wells = @context.executeFetchRequest(@fetch_request, error:error_ptr)
        NSLog("Loaded #{wells.count} wells")
        App.notification_center.post(WellsLoaded, wells)
      else
       raise "Error when fetching wells: #{error_ptr[0].description}"
      end
    }
  end

  def create_well
    yield NSEntityDescription.insertNewObjectForEntityForName('WellInfo', inManagedObjectContext:@context),
        NSEntityDescription.insertNewObjectForEntityForName('WellDetails', inManagedObjectContext:@context)
  end

  def wells
    @wells ||= []
  end

  # The purpose of the load, is to pull in data from an external source, and load it into your CoreData store. It can
  # be invoked from the REPL
  def self.load
    $stdout.sync = true
    # Finds and opens a CSV file, from the resources dir, which contains the data to be loaded
    path = NSBundle.mainBundle.pathForResource("abandoned_wells_20130513", ofType:"csv")
#    path = NSBundle.mainBundle.pathForResource("small_wells", ofType:"csv")
    loaded = 0
    FCSV.foreach( path, headers: true ) do |row|
      WellStore.shared.create_well do |info, details|
        # UWI_DISPLAY,UWI,UWI_SORT,WELL_NAME,CURRENT_STATUS,STATUS,STATUS_DATE,PLOT_SYMBOL,LATITUDE,LONGITUDE
        info.uwi_display = row[0]
        info.well_name = row[3]
        info.status = row[5]
        info.latitude = row[8].to_f
        info.longitude = row[9].to_f
        info.status_date = NSDate.dateWithNaturalLanguageString(row[6]) || NSDate.date
        details.uwi = row[1]
        details.uwi_sort = row[2]
        details.current_status = row[4]
        details.plot_symbol = row[7].to_i
        info.details = details
      end

      # saves records to the store in batches of 100
      loaded += 1
      if ((loaded % 100) == 0)
        WellStore.shared.save
        # prints progress for batches of 100, with marker '*' for 1000's
        print ((loaded % 1000) != 0) ? '.' : '*'
      end
    end

    # One more save, for the odd batch at the end
    WellStore.shared.save
    puts "Loaded #{loaded} wells"
  end

  def save
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
  end

  private

  def initialize
    # Create the model programmatically. Our model has multiple entities, and the data will be stored in a SQLite database, inside the application's Documents folder.
    @mom = NSManagedObjectModel.alloc.init.tap do |m|
      m.entities = [WellInfo, WellDetails].collect {|c| c.entity}
      m.entities.each {|entity| set_entity_properties(entity,m)}
    end
    @store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(@mom)
    error_ptr = Pointer.new(:object)
    unless @store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:{NSReadOnlyPersistentStoreOption:true}, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end

    @context = NSManagedObjectContext.alloc.initWithConcurrencyType(NSPrivateQueueConcurrencyType)
    @context.persistentStoreCoordinator = @store

    @predicate = NSPredicate.predicateWithFormat("(latitude > $min_lat AND latitude < $max_lat) AND (longitude > $min_lng AND longitude < $max_lng)")
    @fetch_request = new_fetch_request
  end

  def new_fetch_request
    fetch_request = NSFetchRequest.new
    fetch_request.entity = NSEntityDescription.entityForName('WellInfo', inManagedObjectContext:@context)
    sort = NSSortDescriptor.alloc.initWithKey('details.uwi_sort', ascending: true)
    fetch_request.sortDescriptors = [sort]

    fetch_request
  end

  def store_url
    NSURL.fileURLWithPath(NSBundle.mainBundle.pathForResource("wells", ofType:"sqlite"))
  end

  def set_entity_properties(entity, model)
    # set up attributes
    managed_object_class = Object.const_get(entity.managedObjectClassName)
    entities = model.entitiesByName

    attributes = managed_object_class.attributes.collect do |attr|
      property = NSAttributeDescription.alloc.init
      property.name = attr[:name]
      property.attributeType = attr[:type]
      property.defaultValue = attr[:default]
      property.optional = attr[:optional]
      property
    end
    # set up relationships
    relationships = managed_object_class.relationships.map do |rel|
      relation = NSRelationshipDescription.alloc.init
      relation.name = rel[:name]
      relation.destinationEntity = entities[rel[:destination]]
      relation.inverseRelationship = entities[rel[:inverse]]
      relation.optional = rel[:optional] || false
      relation.transient = rel[:transient] || false
      relation.indexed = rel[:indexed] || false
      relation.ordered = rel[:ordered] || false
      relation.minCount = rel[:min] || 1
      relation.maxCount = rel[:max] || 1 # NSIntegerMax
      relation.deleteRule = rel[:del] || NSNullifyDeleteRule # NSNoActionDeleteRule NSNullifyDeleteRule NSCascadeDeleteRule
      relation
    end
    # assign properties
    entity.properties = attributes + relationships
  end

end