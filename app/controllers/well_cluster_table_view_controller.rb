class WellClusterTableViewController < UITableViewController

  def preferredStatusBarStyle
    UIStatusBarStyleLightContent
  end

  def viewDidLoad
    super
    navigationItem.title = 'Well List'
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:true)
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @wells.count
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

  def configureCell(cell, atIndexPath:index)
    well = @wells[index.row]
    cell.textLabel.text = well.uwi_display
    cell.detailTextLabel.text = well.well_name
    return cell
  end

  CellID = self.class.name

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
      WellTableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
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

  def show_cluster(wells)
    @wells = wells
    tableView.reloadData
  end
end
