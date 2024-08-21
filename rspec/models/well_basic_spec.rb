require "date"
require_relative "../../app/models/well_basic"
describe WellBasic do
  before do
	  @well = double(:well, uwi_display: "55-5W5", status_date: Date.today) 
		@well_basic = WellBasic.new(@well)
	end
	
	describe "#title" do
	  it "should not be nil" do
			expect(@well_basic.title).not_to be_nil
		end
	end
	
	describe "#subtitle" do
		it "should not be nil" do
			expect(@well_basic.subtitle).not_to be_nil
		end
	end
	
	describe "#coordinate" do
		it "should delegate coordinate to well" do
			expect(@well).to receive(:coordinate)
			@well_basic.coordinate
		end
	end	
end