namespace :demo do

  desc "Create demonstration home builder"
  task :build => :environment do
    superintendent_ids = []
    areamanager_ids = []

    puts "Create builder..."
    rbuilder = Rbuilder.new(
      :username => "demo",
      :first_name => "Demonstration",
      :last_name => "Homes",
      :email => 'demo@demonstration.com',
      :password => "demo1234",
      :password_confirmation => "demo1234",
      :inactive => false
    )
    rbuilder.has_role!('builder')
    if rbuilder.save
      puts "Created rbuilder: #{rbuilder.first_name} #{rbuilder.last_name}"
    else
      puts "COULD NOT CREATE rbuilder: #{rbuilder.first_name} #{rbuilder.last_name}"
      return
    end

    puts "Create superintendents..."
    first_names = %w(Peter    Rudy  Connie   Donald)
    last_names =  %w(Prepared Ready Complete Dunn)
    N_SUPERS = 4
    (0..N_SUPERS-1).each do |index|
      username = ActiveSupport::SecureRandom.hex(5)
      superintendent = Superintendent.new(
        :username => username,
        :first_name => first_names[index],
        :last_name => last_names[index],
        :email => username+'@demonstration.com',
        :password => "demo1234",
        :password_confirmation => "demo1234",
        :inactive => false,
        :rbuilder_id => rbuilder.id
      )
      superintendent.has_role!('superintendent')
      if superintendent.save
        superintendent_ids << superintendent.id
        puts "Created superintendent: #{superintendent.first_name} #{superintendent.last_name}"
      else
        puts "COULD NOT CREATE superintendent: #{superintendent.first_name} #{superintendent.last_name}"
        return
      end
    end

    puts "Create area managers..."
    first_names = %w(John  Sam)
    last_names =  %w(Jones Smith)
    N_AREA_MGRS = 2
    (0..N_AREA_MGRS-1).each do |index|
      username = ActiveSupport::SecureRandom.hex(5)
      areamanager = Areamanager.new(
        :username => username,
        :first_name => first_names[index],
        :last_name => last_names[index],
        :email => username+'@demonstration.com',
        :password => "demo1234",
        :password_confirmation => "demo1234",
        :inactive => false,
        :rbuilder_id => rbuilder.id
      )
      areamanager.has_role!('areamanager')
      if areamanager.save
        areamanager_ids << areamanager.id
        puts "Created area manager: #{areamanager.first_name} #{areamanager.last_name}"
      else
        puts "COULD NOT CREATE area manager: #{areamanager.first_name} #{areamanager.last_name}"
        return
      end
    end

    puts "Copy inspections..."
    streets = %w(Highland Oak Willow Eucalyptus Montecito Montoro Camino Leafy Shady Sunny)
    types = %w(Way St Circle Alley)
    horton = Rbuilder.find(3, :include => :inspection_forms)
    horton.inspection_forms.each do |inspection|
        if rand(8) == 1 && inspection.defects.size > 0
        # duplicate the inspection
        new_inspection = InspectionForm.new(inspection.attributes)
        # change its attributes
        number = 9999 + rand(60000)
        address = "#{number.to_s} #{streets[rand(streets.length)]} #{types[rand(types.length)]}"
        new_inspection.address = address
        new_inspection.superintendent_id = superintendent_ids[rand(N_SUPERS)]
        new_inspection.areamanger_id = areamanager_ids[rand(N_AREA_MGRS)]
        new_inspection.rbuilder_id = rbuilder.id
        new_inspection.itype = "FinalInspection"
        new_inspection.jobnumber = 100000000 + rand(800000000)
        new_inspection.idate = (1+rand(59)).days.ago
        new_inspection.created_at = Time.now
        new_inspection.updated_at = Time.now
        # save it
        if new_inspection.save
          puts("Created inspection  Address= #{address}")
        else
          puts "COULD NOT CREATE inspection: #{new_inspection.inspect}"
          return
        end

        # get all the defects and duplicate them
        inspection.defects.each do |defect|
          new_defect = Defect.new(defect.attributes)
          new_defect.inspection_form_id = new_inspection.id
          new_defect.created_at = Time.now
          new_defect.updated_at = Time.now
          if new_defect.save
            #puts("Created new_defect  new_defect= #{new_defect}")
          else
            puts "COULD NOT CREATE new_defect: #{new_defect.inspect}"
            return
          end
        end

        # get all the comments and duplicate them
        inspection.comments.each do |comment|
          new_comment = Comment.new(comment.attributes)
          new_comment.inspection_form_id = new_inspection.id
          new_comment.created_at = Time.now
          new_comment.updated_at = Time.now
          if new_comment.save
            #puts("Created new_comment  new_comment= #{new_comment}")
          else
            puts "COULD NOT CREATE new_comment: #{new_comment.inspect}"
            return
          end
        end

        #break # left in gives only one new inspection
       end
    end

  end

end

