class ThemeTableViewCell2 < ThemeTableViewCell

  def initWithStyle(style, reuseIdentifier:ident)
    super.tap do |cell|
      cell.textLabel.textColor = Theme::Base.color_theme[:dark_text]
      cell.detailTextLabel.textColor = Theme::Base.color_theme[:light_text]
    end
  end
end