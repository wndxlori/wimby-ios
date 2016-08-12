class UIView
  def findVisualEffectsSubview
    found = nil
    if self.isKindOfClass(UIVisualEffectView)
      found = self
    else
      self.subviews.each do |sv|
        found = sv.findVisualEffectsSubview
        break unless found.nil?
      end
    end
    found
  end
end