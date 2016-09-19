class WimbyViewController < UIViewController
  attr_accessor :search_active
  stylesheet :menu_sheet

  # This doesn't appear to work
  def preferredStatusBarStyle
    UIStatusBarStyleDefault
  end

  def viewDidLoad
    super

    @table_view_controller = UITableViewController.alloc.initWithStyle UITableViewStyleGrouped
    @table_view_controller.tableView.dataSource = self
    @table_view_controller.tableView.delegate = self
    @table_view_controller.tableView.remembersLastFocusedIndexPath = false
    @table_view_controller.tableView.backgroundView = UIView.alloc.initWithFrame(CGRectZero)

    #Create a UIScrollView subview and add a UITableView into it as a subview
    @scroll_view = subview UIScrollView, :scroll_view do
      subview @table_view_controller.tableView, :table_view
    end

    setup_search_bar
    setup_geocoder
  end

  def viewWillAppear(_)
    UIApplication.sharedApplication.delegate.log_event('show-menu')
  end

  def setup_search_bar
    @search_bar = UISearchBar.alloc.initWithFrame(CGRectMake(0, 0, 320, 44))
    @search_bar.delegate = self
    @table_view_controller.tableView.tableHeaderView = @search_bar
    @search_bar.sizeToFit
    @search_bar.placeholder = 'Enter city/town'
    @search_bar.barStyle = UIBarStyleBlack
    @search_bar.translucent = true
  end

  def setup_geocoder
    @geocode_placemarks = []
    @geocoder = CLGeocoder.new
  end

  #
  # When a search is active, we will have 3 sections/groups in the table,
  # otherwise there will be only 2
  #
  def source_for(section)
    if self.search_active
      case section
        when 0
          @geocode_placemarks
        when 1
          Location.previous
        when 2
          Location::Interesting
      end
    else
      section == 0 ? Location.previous : Location::Interesting
    end
  end

  def location_at(indexPath)
    location = source_for(indexPath.section)[indexPath.row]
    self.search_active && indexPath.section == 0 ? Location.initWithPlacemark(location) : location
  end

  # data source
  def tableView(tableView, numberOfRowsInSection:section)
    source_for(section).size
  end

  def numberOfSectionsInTableView(_)
    self.search_active ? 3 : 2
  end

  def tableView(tableView, titleForHeaderInSection:section)
    if self.search_active
      case section
        when 0
          'Search Results'
        when 1
          'Previous Locations'
        when 2
          'Interesting Locations'
      end
    else
      section == 0 ? 'Previous Locations' : 'Interesting Locations'
    end
  end

  HeaderFooterID = 'theme'

  def tableView(tableView, viewForHeaderInSection:section)
    tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderFooterID) || begin
      tableView.registerClass(ThemeTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier:HeaderFooterID)
      tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderFooterID)
    end
  end

  def tableView(tableView, viewForFooterInSection:section)
    tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderFooterID) || begin
      tableView.registerClass(ThemeTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier:HeaderFooterID)
      tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderFooterID)
    end
  end

  CellID = 'LocIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
      cell = ThemeTableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell.prepare_disclosure_indicator
      cell
    end

    location = source_for(indexPath.section)[indexPath.row]
    cell.textLabel.text = location.name
    cell
  end

  # delegate
  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleNone
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    Location.current_location = location_at(indexPath)
    self.reset_search

    # Set the map to be the current tab
    controller = UIApplication.sharedApplication.delegate.tab_bar_controller
    controller.selectedIndex = 0

    UIApplication.sharedApplication.delegate.slide_menu_controller.closeMenuBehindContentViewController(controller, animated:true, completion:nil)
  end

  def reset_search
    @search_bar.text = nil
    @search_bar.resignFirstResponder
    self.search_active = false
    @table_view_controller.tableView.reloadData
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
          @geocode_placemarks = placemarks
        end
        @table_view_controller.tableView.reloadData
      })
    end
  end
end