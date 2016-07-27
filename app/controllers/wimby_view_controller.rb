class WimbyViewController < UIViewController
  attr_accessor :search_active
  stylesheet :menu_sheet

  def viewDidLoad
    super
    @table_view_controller = UITableViewController.alloc.initWithStyle UITableViewStyleGrouped
    @table_view_controller.tableView.dataSource = self
    @table_view_controller.tableView.delegate = self

    #Create a UIScrollView subview and add a UITableView into it as a subview
    @scroll_view = subview UIScrollView, :scroll_view do
      subview @table_view_controller.tableView, :table_view
    end

    # setup_search_controller
    # setup_search_bar(@search_controller.searchBar)
    @search_bar = UISearchBar.alloc.initWithFrame(CGRectMake(0, 0, 320, 44))
    setup_search_bar(@search_bar)
    setup_geocoder
  end

  def setup_search_controller
    @search_controller = UISearchController.alloc.initWithSearchResultsController(nil)
    @search_controller.searchResultsUpdater = self
    @search_controller.dimsBackgroundDuringPresentation = false
  end
  
  def setup_search_bar(search_bar)
    search_bar.delegate = self
    @table_view_controller.tableView.tableHeaderView = search_bar
    search_bar.sizeToFit
    search_bar.placeholder = 'Enter location'
    # search_bar.showsSearchResultsButton = true
    # search_bar.showsCancelButton = true
  end

  def setup_geocoder
    @geocode_placemarks = []
    @geocoder = CLGeocoder.new
  end

  # data source
  def tableView(tableView, numberOfRowsInSection:section)
    if self.search_active
      @geocode_placemarks.count
    elsif numberOfSectionsInTableView(tableView) > 1 and section == 0
      Location::Previous.size
    else
      Location::Interesting.size
    end
  end

  def numberOfSectionsInTableView(tableView)
    if self.search_active
      1
    else
      Location::Previous.size > 0 ? 2 : 1
    end
  end

  def tableView(tableView, titleForHeaderInSection:section)
    if !self.search_active
      if numberOfSectionsInTableView(tableView) > 1 and section == 0
        'Previous Locations'
      else
        'Interesting Locations'
      end
    end
  end

  CellID = 'LocIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell
    end

    if self.search_active
      location = @geocode_placemarks[indexPath.row]
    elsif numberOfSectionsInTableView(tableView) > 1 and indexPath.section == 0
      location = Location::Previous[indexPath.row]
    else
      location = Location::Interesting[indexPath.row]
    end
    cell.textLabel.text = location.name
    cell
  end

  # delegate
  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleNone
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    location = if self.search_active
      Location.initWithPlacemark(@geocode_placemarks[indexPath.row])
    elsif numberOfSectionsInTableView(tableView) > 1 and indexPath.section == 0
      Location::Previous[indexPath.row]
    else
      Location::Interesting[indexPath.row]
    end
    App::Persistence['current_location'] = {title: location.title, latitude: location.latitude, longitude: location.longitude }
    App.notification_center.post(LocationEntered, location)

    # Set the map to be the current tab
    controller = UIApplication.sharedApplication.delegate.tab_bar_controller
    controller.selectedIndex = 0

    UIApplication.sharedApplication.delegate.slide_menu_controller.closeMenuBehindContentViewController(controller, animated:true, completion:nil)
  end

 def searchBar(search_bar, textDidChange: search_text)
    if search_text.size < 3
      self.search_active = false
    else
      self.search_active = true
      search_text_in_canada = "#{search_text}, CANADA"
      @geocoder.geocodeAddressString(search_text_in_canada, completionHandler: lambda {|placemarks, err|
        if err || placemarks.size == 0
          puts err.to_s
          @geocode_placemarks = []
        else
          placemarks.each { |pm| puts pm.name }
          @geocode_placemarks = placemarks
        end
      })
    end
    @table_view_controller.tableView.reloadData
  end
end