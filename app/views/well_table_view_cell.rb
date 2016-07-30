class WellTableViewCell < UITableViewCell

  def initWithStyle(style, reuseIdentifier:ident)
    super.tap do |cell|
      cell.backgroundColor = Theme.color_theme[:cell_background_color]
      cell.textLabel.textColor = UIColor.lightTextColor #Theme.color_theme[:tint]
      cell.detailTextLabel.textColor = UIColor.lightTextColor #Theme.color_theme[:tint]
    end
  end
end