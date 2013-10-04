class Location
  def initialize(lat, long, name)
    @name = name
    @coordinate = CLLocationCoordinate2D.new
    @coordinate.latitude = lat
    @coordinate.longitude = long
  end

  def title; @name; end
  def coordinate; @coordinate; end

  Previous = App::Persistence['previous_locations'].nil? ? [] : App::Persistence['previous_locations']

  Interesting =
    [
      Location.new(50.6739032, -114.2788625, 'Turner Valley, AB'),
      Location.new(50.67024, -114.275143, 'Medicine Hat, AB'),
      Location.new( 53.2722685, -113.5434225, 'Midale, SK')
    ]
end


#Turner Valley
#
#https://www.google.com/maps/preview#!q=TURNER+VALLEY&data=!4m16!2m15!1m14!1s0x5371a5628a36134f%3A0x1cb191127698a759!3m8!1m3!1d17595!2d-114.275143!3d50.67024!3m2!1i1280!2i668!4f13.1!4m2!3d50.6739032!4d-114.2788625!5e1
#
#Medicine Hat
#
#https://www.google.com/maps/preview#!q=Medicine+Hat%2C+AB%2C+Canada&data=!4m10!1m9!4m8!1m3!1d17595!2d-114.275143!3d50.67024!3m2!1i1280!2i668!4f13.1
#
#Leduc
#
#https://www.google.com/maps/preview#!q=Leduc%2C+AB%2C+Canada&data=!4m10!1m9!4m8!1m3!1d71305!2d-110.7093926!3d50.0514124!3m2!1i1280!2i668!4f13.1
#
#Midale
#
#https://www.google.com/maps/preview#!q=Midale%2C+SK%2C+Canada&data=!4m11!1m10!2i6!4m8!1m3!1d66409!2d-113.5434225!3d53.2722685!3m2!1i1280!2i668!4f13.1
#
#Carnduff
#
#https://www.google.com/maps/preview#!q=Carnduff%2C+SK%2C+Canada&data=!4m10!1m9!4m8!1m3!1d289909!2d-101.9075588!3d49.2579456!3m2!1i1280!2i668!4f13.1
#
#Suffield
#
#https://www.google.com/maps/preview#!q=Suffield%2C+AB%2C+Canada&data=!4m10!1m9!4m8!1m3!1d9075!2d-101.795721!3d49.1752495!3m2!1i1280!2i668!4f13.1
#
#Cold Lake
#
#https://www.google.com/maps/preview#!q=Cold+Lake%2C+AB%2C+Canada&data=!4m10!1m9!4m8!1m3!1d566505!2d-113.6132034!3d50.3817313!3m2!1i1280!2i668!4f13.1
#
#Crane Lake
#
#https://www.google.com/maps/preview#!q=Crane+Lake%2C+Bonnyville+No.+87%2C+AB%2C+Canada&data=!4m10!1m9!4m8!1m3!1d64586!2d-110.2451484!3d54.4372129!3m2!1i1280!2i668!4f13.1