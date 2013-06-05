class WellTableViewController < UITableViewController

  include NSFetchedResultsControllerDelegate

  def init
    super.tap do
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('List', image:UIImage.imageNamed('list.png'), tag:2)
    end
  end

  def viewDidLoad
    super
    error_ptr = Pointer.new(:object)
    @fetch_controller = WellStore.shared.fetched_results_controller
    @fetch_controller.delegate = self
    unless @fetch_controller.performFetch(error_ptr)
      raise "Error when fetching wells: #{error_ptr[0].description}"
    end
  end

  def viewDidUnload
    @fetch_controller = nil
  end

  def viewWillAppear(animated)
    navigationItem.title = 'Wells on Map'
    #navigationItem.leftBarButtonItem = editButtonItem
    #navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add_well')
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
end