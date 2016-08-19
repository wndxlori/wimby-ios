class AboutViewController < UIViewController
  stylesheet :about_sheet

  def init
    super.tap do
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('About', image:'Info Icon - Inactive.png'.uiimage, selectedImage:'Info Icon - Active.png'.uiimage)
      navigationItem.title = 'About WIMBY'
      navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage(
        'Search Icon - Inactive.png'.uiimage,
        style: UIBarButtonItemStylePlain,
        target: self,
        action: "show_menu"
      )
      self.edgesForExtendedLayout = UIRectEdgeNone
    end
  end

  layout :root do
    @text_label = subview UITextView, :text_view, text: about_text
  end

  def preferredStatusBarStyle
    UIStatusBarStyleLightContent
  end

  # Show/hide the slidemenucontroller
  def show_menu
    self.navigationController.slideMenuController.toggleMenuAnimated(self)
  end

  def about_text
<<EOS
WIMBY was an idea I had, quite a few years ago, after reading about an incident w.r.t. an improperly abandoned well in the community of Calmar, AB (more on that later). At the time, I was working with oil & gas data every day (in the development of etriever.com and welltriever.com), and I was appalled at the idea people could have an abandoned well in their back yard, and not be aware of it.

As of the time I wrote this blurb, there were 803928 licensed wells in Canada (numbers courtesy of etriever.com).  That includes water/steam wells, but there were only 16177 of those, so they hardly count against that somewhat mind-boggling total.

Of those 800K wells, 297417 of them were “abandoned”.  This is an official oil industry designation, wherein the wells are no longer being operated, and the mineral leases have been returned to the provincial government. These “abandoned" wells are not the “inactive” wells about which there has been much coverage in the news recently.
http://www.ecojustice.ca/wp-content/uploads/2014/12/IWCP-Paper-FINAL-20-Nov-2014.pdf
http://boereport.com/2016/04/19/albertas-inactive-well-problem-incentives-needed-to-kickstart-reclamations-who-can-afford-to-sign-blank-cheques/
http://calgaryherald.com/business/energy/5-things-abandoned-and-inactive-wells-in-alberta
http://globalnews.ca/news/2301432/map-shows-nearly-every-corner-of-alberta-littered-with-inactive-oil-and-gas-wells/

In fact, there’s another 94307 wells that have been “suspended”, which means they are not producing, but the operating company still maintains the mineral lease. In some cases, these wells are just awaiting improved economics, for them to be viable again.  In others, the operating companies have been bankrupted, and they are orphaned.  In both these cases, there would still be a caveat on any surface land title related to these wells, so they aren’t exactly “invisible".

It’s those abandoned wells that are the problem WIMBY is intended to address, and most especially the old ones.  Once the operating company cleans up and the mineral lease is returned to the government, there is no requirement for the caveat to remain on the associated surface land title, so it falls off.  At this point, it is difficult to know that these wells even existed. They are, in effect, invisible.

In the wild-west past of the oil industry, there were no regulations about the abandonment of wells. In the 1960’s the rules and regulations around the abandonment of wells gained some teeth (1963, 1966), and have only become more stringent with time, so wells abandoned after that time are less likely to cause problems (although it’s still nice to know where they were, just in case).
https://www.aer.ca/abandonment-and-reclamation/why-are-wells-abandoned
https://www.aer.ca/documents/directives/Directive020.pdf
http://www.ieaghg.org/docs/WBI3Presentations/TWatson.pdf

Previous to those regulations coming into effect, though, is a grey area. Some companies were good about properly closing these wells in, while others… were not. Thus the debacle at Calmar, AB. Although the original story link has disappeared, I documented the details in a blog post here, when I first created a web application called WIMBY (that web app no longer exists): http://www.wndx.com/blog/gas-leak-forces-out-families

And there is ongoing coverage of the Calmar saga in many places:
http://o.canada.com/news/national/leaky-plumbing-on-energy-wells-seen-as-threat-to-climate-water-and-resources
http://o.canada.com/news/national/five-years-five-homes-demolished-and-gas-keeps-bubbling-from-the-deep
http://www.theglobeandmail.com/news/national/abandoned-oil-wells-jeopardize-alberta-homes/article1372745/
http://www.imperialoil.ca/Canada-English/operations_community_other_calmar.aspx

One of the important things to remember, is that the currently responsible operator of these wells may or may not even be aware of their existence.
http://www.devondispatch.ca/2013/07/02/imperial-oil-starting-third-calmar-well-re-abandonment
All three wells were initially drilled by Texaco, and have been out of use since the 1950’s. Imperial came into ownership of the wells in 1989, but was not aware of their presence until late 2007.

All the data presented in WIMBY (and much more) is available from the various provincial governments
BC - https://www.bcogc.ca
AB - https://www.aer.ca
SK - http://www.economy.gov.sk.ca/oilgas

But it remains difficult to find things, unless you already know where to look (go ahead and try: http://mapviewer.aer.ca/Html5/Index.html?viewer=aerabnwells).

And please, (really PLEASE), don’t expect me, the creator of WIMBY, to do anything about abandoned wells you might be concerned about. You should take those concerns & questions to the relevant provincial authority (as listed above).

WIMBY is my attempt to make the information about Abandoned Wells in Canada easy to find and to put that information directly in the hands of anyone who wants to look. Hopefully, with this information in hand, we won’t ever need to have another Calmar incident.

Hey, and if you like this app, please go and give it a nice rating in the app store!


EOS
  end

end