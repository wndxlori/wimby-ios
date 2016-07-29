class SimpleLocationManager < CLLocationManager
  def init
    super.tap do
      self.desiredAccuracy = KCLLocationAccuracyThreeKilometers
      self.distanceFilter = 5000.0
      self.pausesLocationUpdatesAutomatically = true
    end
  end

  def self.user_location_allowed?
    App::Persistence['user_location_allowed'] == true
  end

  def self.request_user_location(controller)
    alert = UIAlertController.alertControllerWithTitle("WIMBY would like to access your location",
                                   message:"WIMBY uses your location to show abandoned wells near to you",
                                   preferredStyle:UIAlertControllerStyleAlert)

    ok_action = UIAlertAction.actionWithTitle( "OK", style:UIAlertActionStyleDefault,
       handler: ->(_) {App::Persistence['user_location_allowed'] = true; controller.track})
    cancel_action = UIAlertAction.actionWithTitle( "Don't Allow", style:UIAlertActionStyleCancel,
       handler: ->(_) {})

    alert.addAction(cancel_action)
    alert.addAction(ok_action)

    controller.presentViewController(alert, animated:true, completion:nil)
  end
end