namespace :demo do

  desc "Update the dates of the demo inspections to be recent"
  task :dates => :environment do

    puts "Updating inspection dates..."
    demo = User.find_by_username("demo")
    demo.inspection_forms.each do |inspection|
      n = 30+rand(30)
      inspection.update_attribute(:idate, n.days.ago)
    end
    puts "...DONE"

  end

end

