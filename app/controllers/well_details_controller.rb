class WellDetailsController < UIViewController

  stylesheet :details

  layout do
    @label = subview(UILabel, :label, text: 'UWI')
  end

  def viewDidLoad
    super
    navigationItem.title = "Well Details"
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:true)
  end

  def showDetailsForWell(well)
    @label.text = well.uwi_display
  end
end
