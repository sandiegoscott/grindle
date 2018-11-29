namespace :db do

  desc "Change name to Grindle, obscure emails, cut to < 10K rows"
  task :grindle => :environment do

    User.all.each do |user|
      next if user.email.include?('grindle')
      user.email = "#{rand(1000000000)}@grindleinspections.com"
      user.password = 'grindle'
      user.password_confirmation = 'grindle'
      user.save
    end

    created_at_limit = Date.today - 2.months
    InspectionForm.find_each(:batch_size => 1000) do |inspection_form|
      next if inspection_form.created_at > created_at_limit
      inspection_form.destroy
    end

  end

end

