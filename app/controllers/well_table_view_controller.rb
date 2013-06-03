class WellTableViewController < UITableViewController

  include NSFetchedResultsControllerDelegate

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
    navigationItem.title = 'Wells in View'
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
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    configureCell(cell, atIndexPath:indexPath)
  end

  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    WellStore.shared.remove_well(@fetch_controller.objectAtIndexPath(indexPath))
  end
end