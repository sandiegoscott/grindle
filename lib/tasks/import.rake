namespace :db do
  desc "Imports data from CSV files into the database."
  task :import => :environment do
    require "FasterCSV"
 
    path = "./tmp"
    SKIP_TABLES = [ 'schema_migrations' ]
 
    ActiveRecord::Base.establish_connection
    database = ActiveRecord::Base.connection
    puts ">>>>>> database=#{database.inspect}"
    tables = (database.tables - SKIP_TABLES)  # ['users']  #
    puts ">>>>>> tables=#{tables.join ' | '}"
 
    database.disable_referential_integrity do
      Dir.chdir(path) do
        Dir.glob("*.csv") do |file_name|
          table_name = file_name[/(.+).csv/, 1]
          next unless tables.include?(table_name)
 
          rows = FasterCSV.read(file_name)
          puts "\n>>>>>> table_name=#{table_name}  rows=#{rows.size}\n"
 
          # Construct a list of column headings from the first row
          heading_row = rows.shift.map { |heading| database.quote_column_name(heading) }.join(",")
          puts ">>>>>> heading_row=#{heading_row}\n"
 
          rows.each do |row|
            #puts "\n>>>>>>  row=#{row.inspect}\n"
            # Need to escape the data correctly so that inserting is successful
            row_data = row.map { |item| database.quote(item) }.join(",")
            #puts ">>>>>> row_data=#{row_data}\n"
            #puts ("INSERT INTO %s(%s) VALUES (%s);" % [table_name, heading_row, row_data])
            database.execute("INSERT INTO %s(%s) VALUES (%s);" % [table_name, heading_row, row_data])
          end
        end
      end
    end
  end
end
