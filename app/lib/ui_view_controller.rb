class UIViewController
  def view_did_pop?
    navigationController.viewControllers.index{|o| o == self}.nil?
  end
end