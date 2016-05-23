class WimbyViewController < UIViewController
  stylesheet :menu_sheet

  def viewDidLoad
    super
    @table_view_controller = UITableViewController.alloc.initWithStyle UITableViewStyleGrouped
    @table_view_controller.tableView.dataSource = self
    @table_view_controller.tableView.delegate = self

    subview(UIView, :container) do
      @location_input = subview(UITextField, :location_input)
    end
    #Create a UIScrollView subview and add a UITableView into it as a subview
    @scroll_view = subview UIScrollView, :scroll_view do
      subview @table_view_controller.tableView, :table_view
    end
  end


  # Table of Previous Locations
  # data source
  def tableView(tableView, numberOfRowsInSection:section)
    if numberOfSectionsInTableView(tableView) > 1 and section == 0
      Location::Previous.size
    else
      Location::Interesting.size
    end
  end

  def numberOfSectionsInTableView(tableView)
    Location::Previous.size > 0 ? 2 : 1
  end

  def tableView(tableView, titleForHeaderInSection:section)
    if numberOfSectionsInTableView(tableView) > 1 and section == 0
      'Previous Locations'
    else
      'Interesting Locations'
    end
  end

  CellID = 'LocIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell
    end
    if numberOfSectionsInTableView(tableView) > 1 and indexPath.section == 0
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
    location = if numberOfSectionsInTableView(tableView) > 1 and indexPath.section == 0
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
end