class WellClusterTableViewController < UITableViewController

  def preferredStatusBarStyle
    UIStatusBarStyleLightContent
  end

  def viewDidLoad
    super
    navigationItem.title = 'Well List'
    self.view.registerClass(ThemeTableViewCell.self, forCellReuseIdentifier:self.class.name)
  end

  def viewWillAppear(_)
    navigationController.setNavigationBarHidden(false, animated:true)
    UIApplication.sharedApplication.delegate.log_event('show-cluster-table')
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @wells.count
  end

  def configureCell(cell, atIndexPath:index)
    well = WellBasic.new(@wells[index.row])
    cell.textLabel.text = well.title
    cell.detailTextLabel.text = well.subtitle
    return cell
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(self.class.name)
    configureCell(cell, atIndexPath:indexPath)
  end

  # Ya.  Don't let people delete the wells
  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleNone
  end

  # def selectWellAtIndexPath(indexPath)
  #   well = @wells[indexPath.row]
  #   controller = UIApplication.sharedApplication.delegate.well_details_controller
  #   controller.showDetailsForWell(well)
  #   self.navigationController.pushViewController(controller, animated:true)
  # end
  #
  # def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
  #   selectWellAtIndexPath(indexPath)
  # end
  #
  # def tableView(tableView, didSelectRowAtIndexPath:indexPath)
  #   selectWellAtIndexPath(indexPath)
  # end

  # Show/hide the slidemenucontroller
  def show_menu(sender)
    self.navigationController.slideMenuController.toggleMenuAnimated(self)
  end

  def show_cluster(wells)
    @wells = wells
    tableView.reloadData
  end
end
