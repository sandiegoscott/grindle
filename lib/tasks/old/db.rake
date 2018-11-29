namespace :db do
  desc "clean up db from Dreamhost"
  task :cleanup => :environment do

    # validate all dates
    puts "Validating dates..."
    default_datetime = DateTime.parse("2009-01-01 01:00:00 -0500")
    User.all.each do |user|
      #puts(">>>>>>>> user.id=#{user.id}")
      if user.last_login_at.blank? || user.last_login_at.blank?
        puts(">>>>>>>> user.id=#{user.id} CORRECTING DATE PROBLEM")
        user.last_login_at    = default_datetime if user.last_login_at.blank?
        user.current_login_at = default_datetime if user.current_login_at.blank?
        user.save
      end
    end

    # create slugs for existing inspections
    puts "Creating slugs..."
    InspectionForm.all.each do |inspection|
      #puts(">>>>>>>> inspection=#{inspection.inspect}")
      unless inspection.slug
        puts(">>>>>>>> ADDING SLUG inspection.id=#{inspection.id}")
        inspection.slug = ActiveSupport::SecureRandom.hex(16)
        inspection.save!
      end
    end

    # remove orphan inspections
    puts "Removing orphan inspections..."
    InspectionForm.all.each do |inspection|
      #puts(">>>>>>>> inspection=#{inspection.inspect}")
      flag = false
      unless inspection.subdivision
        puts(">>>>>>>> NO SUBDIVISION inspection.id=#{inspection.id}")
        flag = true
      end
      unless inspection.rbuilder
        puts(">>>>>>>> NO RBUILDER inspection.id=#{inspection.id}")
        flag = true
      end
      inspection.destroy if flag
    end

    # remove orphan defects
    puts "Removing orphan defects..."
    Defect.all.each do |defect|
      #puts(">>>>>>>> defect=#{defect.inspect}")
      unless defect.inspection_form
        puts(">>>>>>>> NO INSPECTION_FORM defect.id=#{defect.id}")
        defect.destroy
      end
    end

    # capitalize properly
    puts "Capitalizing..."
    InspectionForm.all.each do |inspection|
      #puts(">>>>>>>> inspection=#{inspection.inspect}")
      city = inspection.city.to_s
      capcity = city.split(' ').each{|word| word.capitalize!}.join(' ')
      if city != capcity
        inspection.city = capcity
        inspection.save!
        puts(">>>>>>>> CAPITALIZED #{city} to #{capcity}")
      end
      state = inspection.state.to_s
      capstate = state.upcase
      if state != capstate
        inspection.state = capstate
        inspection.save!
        puts(">>>>>>>> CAPITALIZED #{state} to #{capstate}")
      end
    end

  end

end

