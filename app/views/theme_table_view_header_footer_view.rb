class ThemeTableViewHeaderFooterView < UITableViewHeaderFooterView

  def initWithReuseIdentifier(reuseIdentifier)
    super.tap do |view|
      view.contentView.backgroundColor = Theme::Base.color_theme[:dark_text]
    end
  end

end
