class WimbyViewController < UIViewController
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

    setup_search_controller
    setup_geocoder
  end

  def setup_search_controller
    @search_controller = UISearchController.alloc.initWithSearchResultsController(nil)
    @search_controller.searchResultsUpdater = self
    @search_controller.dimsBackgroundDuringPresentation = false
    @search_controller.searchBar.delegate = self

    @table_view_controller.tableView.tableHeaderView = @search_controller.searchBar
    @search_controller.searchBar.sizeToFit

    self.definesPresentationContext = true
  end

  def setup_geocoder
    @geocode_placemarks = []
    @geocoder = CLGeocoder.new
  end

  # data source
  def tableView(tableView, numberOfRowsInSection:section)
    if @search_controller.isActive
      @geocode_placemarks.count
    elsif numberOfSectionsInTableView(tableView) > 1 and section == 0
      Location::Previous.size
    else
      Location::Interesting.size
    end
  end

  def numberOfSectionsInTableView(tableView)
    if @search_controller.isActive
      1
    else
      Location::Previous.size > 0 ? 2 : 1
    end
  end

  def tableView(tableView, titleForHeaderInSection:section)
    if !@search_controller.isActive
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

    if @search_controller.isActive
      location = @geocode_placemarks[indexPath.row]
    elsif numberOfSectionsInTableView(tableView) > 1 and indexPath.section == 0
      location = Location::Previous[indexPath.row]
    else
      location = Location::Interesting[indexPath.row]
    end
    cell.textLabel.text = location.title
    cell
  end

  # delegate
  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleNone
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    location = if @search_controller.isActive
      MKPlacemark.initWithPlacemark(@geocode_placemarks[indexPath.row])
    elsif numberOfSectionsInTableView(tableView) > 1 and indexPath.section == 0
      Location::Previous[indexPath.row]
    else
      Location::Interesting[indexPath.row]
    end
    App::Persistence['current_location'] = {title: location.title, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude }
    App.notification_center.post(LocationEntered, location)

    # Set the map to be the current tab
    controller = UIApplication.sharedApplication.delegate.tab_bar_controller
    controller.selectedIndex = 0

    UIApplication.sharedApplication.delegate.slide_menu_controller.closeMenuBehindContentViewController(controller, animated:true, completion:nil)
  end

  def updateSearchResultsForSearchController(search_controller)
    search_string = search_controller.searchBar.text
    @geocoder.geocodeAddressString(search_string, completionHandler: lambda {|placemarks, err|
      if placemarks.size == 0
        @geocode_placemarks = []
        UIApplication.sharedApplication.delegate.displayError(self, "WIMBY was unable to find #{address}.")
      else
        @geocode_placemarks = placemarks.select {|pm| pm.country == 'Canada'}
      end
    })
    @table_view_controller.tableView.reloadData
  end
end