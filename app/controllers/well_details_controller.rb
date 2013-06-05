class WellDetailsController < UIViewController
  def loadView
    self.view = UIWebView.alloc.init
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:true)
  end

  def showDetailsForWell(well)
    navigationItem.title = well.uwi_display
    request = NSURLRequest.requestWithURL(NSURL.URLWithString( "http://www.welltriever.com/wells/#{well.details.uwi}"))
    view.loadRequest(request)
  end
end
