class WellDetailsController < UIViewController

  def init
    super.tap do
    end
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:true)
  end

  def showDetailsForWell(well)
    navigationItem.title = well.uwi_display
  end
end
