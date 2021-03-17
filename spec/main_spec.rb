describe "Application 'wimby-ios'" do
  before do
    @app = UIApplication.sharedApplication
    App::Persistence['intro_dismissed'] = true
  end

  it "has one window" do
    @app.windows.size.should == 1
  end
end
