namespace :demo do
  desc "clean up db for demo"
  task :cleanup => :environment do

    # remove inspections with no defects
    puts "Removing inspections without defects..."
    InspectionForm.all.each do |inspection|
      if inspection.defects.size == 0
        puts(">>>>>>>> DESTROY inspection.id=#{inspection.id} inspection.rbuilder_id=#{inspection.rbuilder_id}")
        inspection.destroy
      end
    end

  end

  desc "Fix inspector names"
  task :fixnames => :environment do

    # remove inspectors last names
    puts "Fix names..."
      first_names = ["Susie", "Bobby", "Mickey", "Jodi", "Johnny", "Peter", "Iggy", "Billie", "Mikey", "Missy", "Terry", "Tony", "Tommy", "Jimmie", "Dumbo", "Bingo"]
      last_names = ["Smythe", "Prepared", "Ready", "Complete", "Neat", "Clean", "Gleam", "Shine", "Sparkle", "House", "Home", "Freeman", "Snooze", "Johnson", "Jones", "Smith"]
    Superintendent.all.each do |user|
        first_name = first_names[Kernel.rand(first_names.length)]
        last_name = last_names[Kernel.rand(last_names.length)]

        user.update_attributes(:first_name => first_name)
        user.update_attributes(:last_name => last_name)
        puts("Name= #{first_name} #{last_name}")
    end
    Areamanager.all.each do |user|
        first_name = first_names[Kernel.rand(first_names.length)]
        last_name = last_names[Kernel.rand(last_names.length)]

        user.update_attributes(:first_name => first_name)
        user.update_attributes(:last_name => last_name)
        puts("Name= #{first_name} #{last_name}")
    end

  end

  desc "Fix addresses"
  task :fixaddresses => :environment do

    # remove inspectors last names
    puts "Fix addresses..."
    streets = %w(Highland Oak Willow Eucalyptus Montecito Montoro Camino Leafy Shady Sunny)
    types = %w(Way St Circle Alley)
    InspectionForm.all.each do |inspection|
      if rand(2) == 2
        puts("DESTROY #{inspection.address}")
        inspection.destroy
      else
        number = 9999 + rand(60000)
        address = "#{number.to_s} #{streets[Kernel.rand(streets.length)]} #{types[Kernel.rand(types.length)]}"
        inspection.update_attributes(:address => address)
        puts("Address= #{address}")
      end
    end

  end

  desc "Remove inspections"
  task :rmvinspections => :environment do

    # remove half the inspections
    puts "Remove inspections..."
    InspectionForm.all.each do |inspection|
      if rand(2) == 1
        puts("DESTROY #{inspection.address}")
        inspection.destroy
      end
    end

  end

  desc "remove half the inspections..."
  task :nolast => :environment do

    # remove inspectors last names
    puts "Removing half the inspections..."
    Inspector.all.each do |inspector|
      inspector.update_attributes(:last_name => "Inspector")
    end

  end

end

