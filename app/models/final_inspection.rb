class FinalInspection < InspectionForm
  
  def is_drhorton?
    dr_horton
  end

  CHECKS = ActiveSupport::OrderedHash.new
  CHECKS[:kitchen]      = 'Kitchens - appliances, cabinets, countertops, sink'
  CHECKS[:bathrooms]    = 'Bathrooms - plumbing fixtures, countertops, tubs, showers, light fixtures, exhaust fans, ceramic tiles, cabinets, mirrors'
  CHECKS[:painting]     = 'Painting - Interior & Exterior'
  CHECKS[:doors]        = 'Doors - bifold, bypass, interior, exterior, garage'
  CHECKS[:house_keys]   = 'House Keys - operation'
  CHECKS[:windows]      = 'Windows - screens, sliding glass door, operation & condition'
  CHECKS[:floors]       = 'Floor covering - carpet, vinyl, or tile. Care of such.'
  CHECKS[:fireplace]    = 'Fireplace operation instructions'
  CHECKS[:brick]        = 'Brick (masonry) - appearance, weep holes, expansion joints, flashings'
  CHECKS[:roof]         = 'Roof covering - shingles, roof jacks, flashings, vents'
  CHECKS[:exterior]     = 'Exterior - siding & trim'
  CHECKS[:operation]    = 'Operation of thermostat, furnace, A/C, and air filter, water heater'
  CHECKS[:detectors]    = 'Smoke detectors, ground fault circuit interrupters'
  CHECKS[:electrical1]  = 'Electrical fixtures & devices'
  CHECKS[:electrical2]  = 'Electrical panel boxes'
  CHECKS[:concrete]     = 'Concrete - porch, patio, sidewalk, garage floor'
  CHECKS[:lot]          = 'Lot - grading, maintenance, grass, trees, shrubs'
  CHECKS[:locations]    = 'Location of meters, water faucets, cutoffs, sewer clean outs'
  CHECKS[:warranty]     = 'Warranty booklets on appliances & equipment'
  CHECKS[:utility]      = 'Utility - Homeowner washer drain knockout and washer drain installation'

  LETTERS = ActiveSupport::OrderedHash.new
  LETTERS[:kitchen]      = 'A'
  LETTERS[:bathrooms]    = 'B'
  LETTERS[:painting]     = 'C'
  LETTERS[:doors]        = 'D'
  LETTERS[:house_keys]   = 'E'
  LETTERS[:windows]      = 'F'
  LETTERS[:floors]       = 'G'
  LETTERS[:fireplace]    = 'H'
  LETTERS[:brick]        = 'I'
  LETTERS[:roof]         = 'J'
  LETTERS[:exterior]     = 'K'
  LETTERS[:operation]    = 'L'
  LETTERS[:detectors]    = 'M'
  LETTERS[:electrical1]  = 'N'
  LETTERS[:electrical2]  = 'O'
  LETTERS[:concrete]     = 'P'
  LETTERS[:lot]          = 'Q'
  LETTERS[:locations]    = 'R'
  LETTERS[:warranty]     = 'S'
  LETTERS[:utility]      = 'T'

end
