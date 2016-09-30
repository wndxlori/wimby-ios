module Theme

  RUST = {
    primary: [
      {red:0.455, green:0.263, blue:0.000, alpha:1.0},
      {red:0.859, green:0.498, blue:0.000, alpha:1.0},
      {red:1.000, green:0.580, blue:0.000, alpha:1.0},
      {red:1.000, green:0.643, blue:0.157, alpha:1.0},
      {red:1.000, green:0.792, blue:0.506, alpha:1.0},
    ],
    complement: [
      {red:0.008, green:0.165, blue:0.294, alpha:1.0},
      {red:0.016, green:0.310, blue:0.553, alpha:1.0},
      {red:0.035, green:0.486, blue:0.859, alpha:1.0},
      {red:0.184, green:0.557, blue:0.867, alpha:1.0},
      {red:0.463, green:0.675, blue:0.855, alpha:1.0},
    ]
  }
  class Base

    def self.apply(theme, to_window:window)
      self.color_theme = theme
      window.tintColor = self.color_theme[:tint]
      Dispatch.once do
        UIWindow.appearance.tap do |a|
          a.tintColor = self.color_theme[:tint]
        end
        UITabBar.appearance.tap do |a|
          a.barTintColor = self.color_theme[:tabbar_tint]
        end
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UINavigationBar.self]).tap do |a|
          a.setTitleTextAttributes({
              NSFontAttributeName => UIFont.fontWithName('Avenir-Light', size: 15.0),
            }, forState:UIControlStateNormal)
        end
        UINavigationBar.appearance.tap do |a|
          a.tintColor = self.color_theme[:nav_tint]
          a.barTintColor = self.color_theme[:navbar_tint]
          a.titleTextAttributes = {
            NSFontAttributeName => UIFont.fontWithName('Avenir-Heavy', size: 18.0),
            NSForegroundColorAttributeName => self.color_theme[:navbar_text],
          }
        end
        UITableView.appearance.tap do |a|
          a.separatorColor = self.color_theme[:cell_highlight_dark]
          a.sectionIndexColor = self.color_theme[:dark_text]
          a.sectionIndexBackgroundColor = self.color_theme[:group_table_dark]
          a.backgroundColor = self.color_theme[:group_table_dark]
        end
        UILabel.appearanceWhenContainedInInstancesOfClasses([UITableViewHeaderFooterView.self]).tap do |a|
          a.textColor = self.color_theme[:dark_text]
        end
        UIActivityIndicatorView.appearance.tap do |a|
          a.color = self.color_theme[:tint]
        end
      end
    end

    def self.color_theme
      @@color_theme
    end

    def self.theme_color(theme, selector, scheme = :primary)
      UIColor.colorWithRed(
          theme[scheme][selector][:red],
          green: theme[scheme][selector][:green],
          blue: theme[scheme][selector][:blue],
          alpha: theme[scheme][selector][:alpha]
      )
    end

    def self.color_theme=(theme)
      @@color_theme = {
        tint: theme_color(theme, 3),
        tabbar_tint: theme_color(theme, 0),
        nav_tint: theme_color(theme, 0),
        navbar_tint: theme_color(theme, 2),
        navbar_text: theme_color(theme, 4),
        light_text: theme_color(theme, 4),
        dark_text: theme_color(theme, 1),
        cell_background: theme_color(theme, 4),
        cell_highlight: theme_color(theme, 1),
        cell_highlight_dark: UIColor.colorWithRed(0.25, green: 0.21, blue: 0.19, alpha: 1.00),
        group_table_dark: UIColor.colorWithRed(0.25, green: 0.21, blue: 0.19, alpha: 1.00),
      }
    end

    def self.imageWithColor(color)
      size = CGSizeMake(30, 30)
      # create context with transparent background
      UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen.scale)

      # Add a clip before drawing anything, in the shape of an rounded rect
      UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0,0,30,30), cornerRadius:5.0).addClip
      color.setFill

      UIRectFill(CGRectMake(0, 0, size.width, size.height))
      image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      image
    end
  end
end