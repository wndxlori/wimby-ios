class ThemeTableViewHeaderFooterView < UITableViewHeaderFooterView

  def initWithReuseIdentifier(reuseIdentifier)
    super.tap do |view|
      view.contentView.backgroundColor = UIColor.darkGrayColor
    end
  end

end
