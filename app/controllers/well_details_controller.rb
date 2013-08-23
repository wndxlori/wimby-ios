class WellDetailsController < UITableViewController

  stylesheet :details

  def viewDidLoad
    super
    navigationItem.title = "Well Details"
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:true)
  end

  def showDetailsForWell(well)
    tableView.reloadData
  end
end
