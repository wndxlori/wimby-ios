class WellTableViewController < UITableViewController

  include NSFetchedResultsControllerDelegate
  attr_accessor :fetch_controller

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
    @fetch_controller = WellStore.shared.fetched_results_controller
    @fetch_controller.delegate = self
  end

  def viewDidLoad
    super
    @fetch_controller ||= WellStore.shared.fetched_results_controller
  end

  def viewWillAppear(animated)
    Dispatch::Queue.concurrent(:high).async do
      if @fetch_controller.performFetch(error_ptr = Pointer.new(:object))
        tableView.reloadData
      else
       raise "Error when fetching wells: #{error_ptr[0].description}"
      end
    end
  end

  def viewDidUnload
    @fetch_controller = nil
    super
  end

  def tableView(tableView, numberOfRowsInSection:section)
    fetch_controller.fetchedObjects.count
  end

  def configureCell(cell, atIndexPath:index)
    well = fetch_controller.objectAtIndexPath(index)
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

  def selectWellAtIndexPath(indexPath)
    well = fetch_controller.fetchedObjects[indexPath.row]
    controller = UIApplication.sharedApplication.delegate.well_details_controller
    controller.showDetailsForWell(well)
    self.navigationController.pushViewController(controller, animated:true)
  end

  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    selectWellAtIndexPath(indexPath)
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    selectWellAtIndexPath(indexPath)
  end

  # Show/hide the slidemenucontroller
  def show_menu(sender)
    self.navigationController.slideMenuController.toggleMenuAnimated(self)
  end

end