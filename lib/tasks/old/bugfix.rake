namespace :bugfix do
  desc "make sure each builder has at least a None superintendent and area manager"
  task :none => :environment do

    # remove inspections with no defects
    puts "Checking builders..."
    Rbuilder.all.each do |rbuilder|
      if rbuilder.superintendents.size == 0
        puts(">>>>>>>> CREATE None superintendent for #{rbuilder.full_name}")
        superintendent = Superintendent.new(
          {:username => (rbuilder.username+'-super'), :first_name => 'None',
           :last_name => '', :password => "nopassword", :password_confirmation => "nopassword",
           :email => (rbuilder.username+'-super@none.com'), :rbuilder_id => rbuilder.id, :inactive => false})
        flag = superintendent.save
      end
      if rbuilder.areamanagers.size == 0
        puts(">>>>>>>> CREATE None area manager for #{rbuilder.full_name}")
        areamanager = Areamanager.new(
          {:username => (rbuilder.username+'-areamanager'), :first_name => 'None',
           :last_name => '', :password => "nopassword", :password_confirmation => "nopassword",
           :email => (rbuilder.username+'-areamanager@none.com'), :rbuilder_id => rbuilder.id, :inactive => false})
        flag = areamanager.save
      end
    end

  end
end

