class Theme

  RUST = [
    {red:0.922, green:0.337, blue:0.008, alpha:1.0},
    {red:0.729, green:0.290, blue:0.043, alpha:1.0},
    {red:0.592, green:0.231, blue:0.031, alpha:1.0},
    {red:0.412, green:0.149, blue:0.000, alpha:1.0},
    {red:0.243, green:0.086, blue:0.000, alpha:1.0},
  ]

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
      end
    end
  end

  def self.color_theme
    @@color_theme
  end

  def self.theme_color(theme, selector)
    UIColor.colorWithRed(
        theme[selector][:red],
        green: theme[selector][:green],
        blue: theme[selector][:blue],
        alpha: theme[selector][:alpha]
    )
  end

  def self.color_theme=(theme)
    @@color_theme = {
        tint: theme_color(theme, 0),
        bar_tint: theme_color(theme, 3),
        cell_background_color: theme_color(theme, 4)
    }
  end
end