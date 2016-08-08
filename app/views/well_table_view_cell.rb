class WellTableViewCell < ThemeTableViewCell
  def initWithStyle(style, reuseIdentifier:ident)
    super.tap do |cell|
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell.prepare_disclosure_indicator
    end
  end

end