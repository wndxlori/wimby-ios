class ThemeTableViewCell < UITableViewCell

  def initWithStyle(style, reuseIdentifier:ident)
    super.tap do |cell|
      cell.backgroundColor = UIColor.blackColor
      cell.textLabel.textColor = Theme::Base.color_theme[:dark_text]
      cell.detailTextLabel.textColor = Theme::Base.color_theme[:dark_text]

      highlightView = UIView.alloc.init
      highlightView.backgroundColor = Theme::Base.color_theme[:cell_highlight_dark]
      cell.selectedBackgroundView = highlightView
    end
  end

  # Because without this, the > remains grey, like an asshole
  def prepare_disclosure_indicator
    self.subviews.select {|view| view.isKindOfClass(UIButton)}.each do |button|
      image = button.backgroundImageForState(UIControlStateNormal).imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
      button.setBackgroundImage(image, forState: UIControlStateNormal)
    end
  end

end