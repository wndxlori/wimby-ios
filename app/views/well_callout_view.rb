class WellCalloutView < ThemeCalloutView

  def init(annotation)
    super.tap do
      configure
      updateContentsForAnnotation(annotation)
    end
  end

  def title_label
    @title_label ||= UILabel.new.tap do |label|
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textColor = Theme::Base.color_theme[:tint]
      label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)
    end
  end

  def subtitle_label
    @subtitle_label ||= UILabel.new.tap do |label|
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textColor = Theme::Base.color_theme[:tint]
      label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
    end
  end

private

  def configure
    self.translatesAutoresizingMaskIntoConstraints = false

    content_view.addSubview(title_label)
    content_view.addSubview(subtitle_label)

    views = {
        "titleLabel" => title_label,
        "subtitleLabel" => subtitle_label,
    }

    vfl_strings = [
        "V:|-[titleLabel]-[subtitleLabel]-|",
        "H:|-[titleLabel]-|",
        "H:|-[subtitleLabel]-|",
    ]

    vfl_strings.each do |vfl|
      content_view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vfl, options: 0, metrics: nil, views: views))
    end
  end

  def updateContentsForAnnotation(annotation)
    title_label.text = annotation.title
    subtitle_label.text = annotation.subtitle
  end

end