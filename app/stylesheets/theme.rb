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
          a.barTintColor = self.color_theme[:bar_tint]
        end
        UINavigationBar.appearance.tap do |a|
          a.tintColor = self.color_theme[:tint]
          a.barTintColor = self.color_theme[:bar_tint]
          a.titleTextAttributes = {
            NSFontAttributeName => UIFont.fontWithName('AmericanTypewriter-Bold', size: 17.0),
            NSForegroundColorAttributeName => self.color_theme[:tint],
          }
        end
        UITableView.appearance.tap do |a|
          a.separatorColor = self.color_theme[:tint]
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
          bar_tint: theme_color(theme, 0),
          light_text: theme_color(theme, 4),
          dark_text: theme_color(theme, 0),
          cell_background_color: theme_color(theme, 4),
          cell_highlight_color: theme_color(theme, 1),
      }
    end
  end
end