class WellDetailsController < UITableViewController

  stylesheet :details

  SECTIONS = %w(Name Status Location)

  def viewDidLoad
    super
    navigationItem.title = "Well Details"
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:true)
  end

  def numberOfSectionsInTableView(tableView)
    SECTIONS.size
  end

  def tableView(tableView, numberOfRowsInSection:section)
    2
  end

  def tableView(tableView, titleForHeaderInSection:section)
    SECTIONS[section]
  end

  CellID = self.class.name

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue2, reuseIdentifier:CellID)
      cell
    end
    cell.textLabel.text = @details[indexPath.section][indexPath.row][:label]
    cell.detailTextLabel.text = @details[indexPath.section][indexPath.row][:value]
    cell
  end

  def showDetailsForWell(well)
    @details = [
      [
        {label: 'UWI', value: well.uwi_display},
        {label: 'Well Name', value: well.well_name},
      ],
      [
        {label: 'Current', value: well.status},
        {label: 'Updated', value: well.status_date.strftime('%Y-%m-%d')},
      ],
      [
        {label: 'Latitude', value: well.latitude.stringValue},
        {label: 'Longitude', value: well.longitude.stringValue},
      ]
    ]
    tableView.reloadData
  end
end
