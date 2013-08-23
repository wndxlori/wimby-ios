class WellTableViewController < UITableViewController

  include NSFetchedResultsControllerDelegate

  def init
    super.tap do
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('List', image:'list.png'.uiimage, tag:2)
      self.navigationItem.title = 'Wells List'
      self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage(
        'menuicon.png'.uiimage,
        style: UIBarButtonItemStylePlain,
        target: self,
        action: "show_menu:"
      )
    end
  end

  def viewDidLoad
    super
    App.notification_center.observe RegionChanged do |notification|
      update(notification.object)
    end
  end

  def viewWillAppear(animated)
    unless @fetch_controller
      fetch_results
    end
  end

  def viewDidUnload
    App.notification_center.unobserve RegionChanged
    @fetch_controller = nil
    super
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @fetch_controller.sections.objectAtIndex(section).numberOfObjects
  end

  def configureCell(cell, atIndexPath:index)
    well = @fetch_controller.objectAtIndexPath(index)
    cell.textLabel.text = well.uwi_display
    cell.detailTextLabel.text = well.well_name
    return cell
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
      cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
      cell
    end
    configureCell(cell, atIndexPath:indexPath)
  end

  # Ya.  Don't let people delete the wells
  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleNone
  end

  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    well = @fetch_controller.fetchedObjects[indexPath.row]
    controller = UIApplication.sharedApplication.delegate.well_details_controller
    self.navigationController.pushViewController(controller, animated:true)
    controller.showDetailsForWell(well)
  end

  # Show/hide the slidemenucontroller
  def show_menu(sender)
    self.navigationController.slideMenuController.toggleMenuAnimated(self)
  end

  def update(region_hash)
    store = WellStore.shared
    request = store.fetch_request_template(region_hash, forName:WellMapController::MAP_QUERY_NAME)
    fetch_results(request)
  end

  private

  def fetch_results(request=nil)
    @fetch_controller = WellStore.shared.fetched_results_controller(request)
    @fetch_controller.delegate = self
    NSLog("Loading table data")
    queue = Dispatch::Queue.concurrent('com.wndx.wimby.task')
    queue.sync do
      error_ptr = Pointer.new(:object)
      unless @fetch_controller.performFetch(error_ptr)
        raise "Error when fetching wells: #{error_ptr[0].description}"
      end
      tableView.reloadData
    end
  end
end