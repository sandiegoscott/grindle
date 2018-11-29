namespace :db do
  desc "Exports the database contents into CSV files."
  task :export => :environment do
    require "fastercsv"
    require "fileutils"
 
    path = "./tmp"
    SKIP_TABLES = []
 
    ActiveRecord::Base.establish_connection
    database = ActiveRecord::Base.connection
    puts ">>>>>> database=#{database.inspect}"
    
    tables = database.tables - SKIP_TABLES  # ['subdivisions']  #
 
    tables.each do |table_name|
      puts "\n>>>>>> table_name=#{table_name}"
      FasterCSV.open(File.join(path, "#{table_name}.csv"), "w") do |csv|
        # Write column names
        column_names = database.columns(table_name).map(&:name)
        puts ">>>>>> column_names=#{column_names.join('|')}"
        csv << column_names
        # get ready for date and boolean columns
        date_cols = column_names.map {|name| name.include?('_at') || name.include?('date_')}
        puts ">>>>>> date_cols=#{date_cols.join('|')}"
        # Write rows
        database.select_rows("SELECT * FROM %s" % table_name).each do |row|
          #puts ">>>>>>  row=#{row.inspect}"
          # fix date columns
          date_cols.each_with_index do |date_col, i|
            if date_col
              if !row[i].nil? && row[i].class != String
                row[i] = row[i].strftime("%Y-%m-%d %H:%M:%S")
              end
            end
          end
          # fix boolean columns
          row.size.times do |i|
            row[i] = '0' if row[i] == 'f'
            row[i] = '1' if row[i] == 't'
          end
          csv << row
        end
      end
    end
  end
end

#  from  http://www.dominikgrabiec.com/2009/simple-dataset-exportimport-for-rails/