class ThemeTableViewHeaderFooterView < UITableViewHeaderFooterView

  def initWithReuseIdentifier(reuseIdentifier)
    super.tap do |view|
      view.contentView.backgroundColor = Theme::Base.color_theme[:group_table_dark]
    end
  end

end
