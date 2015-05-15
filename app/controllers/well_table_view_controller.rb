class WellTableViewController < UITableViewController

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
    tableView.delegate = self
    tableView.dataSource = self
  end

  def viewWillAppear(animated)
    if @wells.nil?
      @wells = WellStore.shared.wells
      tableView.reloadData
      add_observers unless @has_observers
    end
  end

  def viewWillDisappear(animated)
    if view_did_pop?
      remove_observers
      @wells = nil
    end
    super
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @wells.count
  end

  def configureCell(cell, atIndexPath:index)
    well = @wells[index.row]
    cell.textLabel.text = well.uwi_display
    cell.detailTextLabel.text = well.well_name
    return cell
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
      cell = WellTableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
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
    well = @wells[indexPath.row]
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

private

  def add_observers
    @has_observers = true
    App.notification_center.observe WellsLoaded do |notification|
      @wells = notification.object
      tableView.reloadData
    end
  end

  def remove_observers
    App.notification_center.unobserve WellsLoaded
    @has_observers = false
  end

end