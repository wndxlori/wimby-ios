class ThemeTableViewCell2 < ThemeTableViewCell

  def initWithStyle(style, reuseIdentifier:ident)
    super.tap do |cell|
      cell.textLabel.textColor = Theme::Base.color_theme[:tint]
      cell.selectedBackgroundView.backgroundColor = UIColor.blackColor
    end
  end
end