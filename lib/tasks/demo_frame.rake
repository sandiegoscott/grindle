namespace :demo do

  desc "Create demo frame inspections"
  task :frame => :environment do
    superintendent_ids = []
    areamanager_ids = []

    puts "Find builder..."
    rbuilder = Rbuilder.find_by_username("demo")

    puts "Find superintendents..."
    superintendents = rbuilder.superintendents
    areamanagers = rbuilder.areamanagers

    puts "Copy inspections..."
    streets = %w(Highland Oak Willow Eucalyptus Montecito Montoro Camino Leafy Shady Sunny)
    types = %w(Way St Circle Alley)
    horton = Rbuilder.find(3)
    #frame_inspections = rbuilder.frame_inspections
    horton.frame_inspections.each do |inspection|

      # duplicate the inspection
      new_inspection = InspectionForm.new(inspection.attributes)
      # change the attributes
      number = 9999 + rand(60000)
      address = "#{number.to_s} #{streets[rand(streets.length)]} #{types[rand(types.length)]}"
      new_inspection.address = address
      new_inspection.superintendent_id = superintendents.rand.id # _ids[rand(superintendents.size)]
      new_inspection.areamanger_id = areamanagers.rand.id # [rand(areamanagers.size)]
      new_inspection.rbuilder_id = rbuilder.id
      new_inspection.itype = "FrameInspection"
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

