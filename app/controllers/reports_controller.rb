class ReportsController < ApplicationController
  require 'csv'

  before_filter :require_user, :except => [ :pdf ]
  before_filter :require_rbuilder, :except => [ :pdf ]

  access_control do
    allow :admin, :inspector, :builder, :areamanager
    action :pdf do
      allow anonymous
    end
  end


  def index
    @months, month_dates = month_selections
    @builders = Rbuilder.all(:order => 'username') if current_user.is_admin?
  end


  def units
    @months, month_dates = month_selections
    start_date, end_date = month_dates[params[:month]]
    @inspection_type = params[:id]

    inspections = @rbuilder.inspection_forms.all(
      :conditions => {:idate => start_date..end_date, :itype => @inspection_type},
      :include => :superintendent,
      :order => 'address asc')
    #logger.info(">>>>>>>>>>>> inspections=#{inspections.inspect}")

    @superintendents = inspections.map {|inspection| inspection.superintendent}.uniq
    @superintendents.sort!{|x,y| x.last_name <=> y.last_name }
    @superintendents_from_ids = @superintendents.index_by(&:id)
    #logger.info(">>>>>>>>>>>> @superintendents_from_ids=#{@superintendents_from_ids.inspect}")

    @inspections_from_superintendent_ids = { }
    inspections.group_by(&:superintendent_id).each do |superintendent_id, group|
      @inspections_from_superintendent_ids[superintendent_id] = group
    end
    #logger.info(">>>>>>>>>>>> @inspections_from_superintendent_ids=#{@inspections_from_superintendent_ids.inspect}")

    @title = "#{@rbuilder.full_name} : Defects by Unit and Trade for " + date_description(params[:month], start_date, end_date)
    #total = inspections.size
    #" #{total} #{@inspection_type.slice(0,5)} Inspections"
  end


  def subdivisions
    @months, month_dates = month_selections
    start_date, end_date = month_dates[params[:month]]
    @itype = params[:id]

    subdivisions = @rbuilder.subdivisions.all(
        :include => [:inspection_forms],
        :conditions => ["inspection_forms.idate BETWEEN ? and ? and inspection_forms.itype = ?",
                        start_date, end_date, @itype] )
    #logger.info(">>>>>>>>>> subdivisions.size=#{subdivisions.size}")

    # get counts of each defect in each subdivision as array of arrays
    inspection_counts = { }
    counts = { }
    subdivisions.each do |subdivision|
      inspection_forms = subdivision.inspection_forms.all(
        :conditions => ["idate BETWEEN ? and ? and itype = ?", start_date, end_date, params[:id]])
      inspection_counts[subdivision.name] = inspection_forms.size
      count = { }
      inspection_forms.each do |inspection_form|
        inspection_form.defects.group_by(&:category_id).each do |category_id, defects|
          count[category_id] = count.keys.include?(category_id) ? count[category_id]+defects.length : defects.length
        end
      end
      counts[subdivision.name] = count
    end
    #logger.info(">>>>>>>>>> counts=#{counts.inspect}")

    # alphabetize the subdivisions
    subdivision_names = counts.keys.uniq.sort
    #logger.info("\n>>>>>>>>>> subdivision_names=#{subdivision_names.inspect}\n\n")

    # make a hash mapping category names to category id's
    category_ids = counts.values.map {|count| count.keys }.flatten.uniq
    category_names = Category.find(category_ids).map { |category| category.name }
    category_id_name_array = Category.find(category_ids).map {|category| [category.name, category.id]}
    category_ids_from_names = Hash[*category_id_name_array.flatten]
    #logger.info("\n>>>>>>>>>> category_ids=#{category_ids.inspect}\n\n")
    #logger.info("\n>>>>>>>>>> category_ids_from_names=#{category_ids_from_names.inspect}\n\n")

    # headings: subdivision column titles
    @headings = [ "", subdivision_names ].flatten

    # 1st row: inspection counts
    row = subdivision_names.map {|name| inspection_counts[name].to_s }
    row.unshift("Inpections")  # should be unshift!
    @table = [ row ]

    # further rows: defect counts (nil where no count exists)
    category_names.sort.each do |category_name|
      category_id = category_ids_from_names[category_name]
      row = subdivision_names.map {|subdivision_name| counts[subdivision_name][category_id].to_s}
      row.unshift(category_name)
      @table << row
    end
    #logger.info("\n>>>>>>>>>> @table=#{@table.inspect}\n\n")

    @title = "#{@rbuilder.full_name} : Defects by Subdivision and Trade for " + date_description(params[:month], start_date, end_date)
    #total = inspection_counts.values.map { |v| v.to_i }.inject {|sum, v| sum+v}
    #"#{total} #{@itype.slice(0,5)} Inspections for #{@rbuilder.username}"
  end


  def subdivisions_chart
    @months, month_dates = month_selections
    start_date, end_date = month_dates[params[:month]]
    @itype = params[:id]

    subdivisions = @rbuilder.subdivisions.all(
        :include => [:inspection_forms],
        :conditions => ["inspection_forms.idate BETWEEN ? and ? and inspection_forms.itype = ?",
                        start_date, end_date, @itype] ).uniq
    #logger.info(">>>>>>>>>> subdivisions=#{subdivisions.inspect}")
    #logger.info(">>>>>>>>>> subdivisions.size=#{subdivisions.size}")

    count_hash = { }
    subdivisions.map{|subdivision| count_hash[subdivision.name] = [0, 0]}
    #logger.info(">>>>>>>>>> count_hash=#{count_hash.inspect}")

    # count inspections and defects
    subdivisions.each do |subdivision|
      #logger.info(">>>>>>>>>> subdivision.name=#{subdivision.name}")
      inspection_forms = subdivision.inspection_forms.all(
        :conditions => ["idate BETWEEN ? and ? and itype = ?", start_date, end_date, params[:id]])
      for inspection_form in inspection_forms
        #logger.info(">>>>>>>>>> inspection_form.id=#{inspection_form.id}")
        subdivision_id = inspection_form.subdivision_id
        defect_count = inspection_form.defects.count
        count_hash[subdivision.name][0] = count_hash[subdivision.name][0] + 1
        count_hash[subdivision.name][1] = count_hash[subdivision.name][1] + defect_count
        #logger.info(">>>>>>>>>> count_hash=#{count_hash.inspect}")
      end
    end
    #logger.info(">>>>>>>>>> count_hash=#{count_hash.inspect}")

    # sort subdivision names
    subdivision_names = subdivisions.map{|subdivision| subdivision.name}.sort
    #logger.info(">>>>>>>>>> subdivision_names=#{subdivision_names.inspect}")

    avgs = subdivision_names.map{|name| count_hash[name][1].to_f / count_hash[name][0].to_f}
    #logger.info(">>>>>>>>>> avgs=#{avgs.inspect}")
    maxx = avgs.max.to_i + 1

    ww = subdivisions.size < 17 ? 23 : (500-25)/subdivisions.size-4

    goog    = "http://chart.apis.google.com/chart?"
    type    = "&cht=bhs"
    size    = "&chs=600x#{25+(ww+4)*subdivisions.size}"
    data    = "&chd=t:" + avgs.inject("") {|str, avg| str+sprintf("%3.1f,", avg)}.chop
    axis    = "&chxt=x,y"
    labels  = "&chxl=1:" + subdivision_names.inject("") {|str, name| "|"+name+str}
    scale   = "&chds=0,#{maxx}&chxr=0,0,#{maxx}"
    color   = "&chco=4D89F9"
    width   = "&chbh=#{ww},4"
    #logger.info(">>>>>>>>>>>>>> labels=#{labels}")

    # chm=D,<color>,<data set index>,<data point>,<size>,<priority>
    # chm=tApril+mobile+hits,000000,0,0,13|
    markers = "&chm=" + avgs.inject("") {|str, avg| str+"t  #{sprintf("%d", avg.to_i)},888888,0,-1,11|"}.chop

    @goog   = goog + type + size + data + axis + labels + scale + color + width # + markers
    #logger.info(">>>>>>>>>>>>>> @goog=#{@goog.inspect}")

    @title = "#{@rbuilder.full_name} : Average Defects by Unit and Trade for " + date_description(params[:month], start_date, end_date)
  end


  def superintendent
    @months, month_dates = month_selections
    start_date, end_date = month_dates[params[:month]]
    @itype = params[:id]
    @type = @itype.slice(0,5) # 'Final' or 'Frame'

    inspections = @rbuilder.inspection_forms.find(:all,
      :conditions => ["idate BETWEEN ? and ? AND itype = ?", start_date, end_date, params[:id]])
    #logger.info("\n>>>>>>>>>>>>>> inspections.size =#{inspections.size}\n")
    superintendent_ids = inspections.map {|inspection| inspection.superintendent_id}.uniq
    @superintendents = Superintendent.find(superintendent_ids)
    #logger.info("\n>>>>>>>>>>>>>> @superintendents =#{@superintendents.inspect}\n")

    @table = []
    @superintendents.each do |superintendent|
      super_name = superintendent.first_name + " " + superintendent.last_name
      super_inspections = inspections.select {|inspection| inspection.superintendent == superintendent}
      super_inspection_count = super_inspections.size
      #logger.info("\n>>>>>>>>>>>>>> super_inspections.size=#{super_inspections.size}\n")
      super_defect_count = super_inspections.inject(0) do |count, super_inspection|
        count = count + super_inspection.defects.count
      end
      super_avg_defects = sprintf("%5.1f", super_defect_count.to_f / super_inspection_count.to_f)
      row = [super_name, super_avg_defects, super_inspection_count.to_i, super_defect_count.to_i]
      #logger.info("\n>>>>>>>>>>>>>> row=#{row.inspect}\n")
      @table << row
    end

    @title = "#{@rbuilder.full_name} : Defects by Superintendent for " + date_description(params[:month], start_date, end_date)
  end


  def areamanager
    @months, month_dates = month_selections
    start_date, end_date = month_dates[params[:month]]
    @itype = params[:id]
    @type = @itype.slice(0,5) # 'Final' or 'Frame'

    inspections = @rbuilder.inspection_forms.find(:all,
      :conditions => ["idate BETWEEN ? and ? AND itype = ?", start_date, end_date, params[:id]])
    #logger.info("\n>>>>>>>>>>>>>> inspections.size =#{inspections.size}\n")
    areamanager_ids = inspections.map {|inspection| inspection.areamanger_id}.uniq
    @areamanagers = Areamanager.find(areamanager_ids)
    #logger.info("\n>>>>>>>>>>>>>> @areamanagers =#{@areamanagers.inspect}\n")

    @table = []
    @areamanagers.each do |areamanager|
      mgr_name = areamanager.first_name + " " + areamanager.last_name
      mgr_inspections = inspections.select {|inspection| inspection.areamanager == areamanager}
      mgr_inspection_count = mgr_inspections.size
      #logger.info("\n>>>>>>>>>>>>>> mgr_inspections.size=#{mgr_inspections.size}\n")
      mgr_defect_count = mgr_inspections.inject(0) do |count, mgr_inspection|
        count = count + mgr_inspection.defects.count
      end
      mgr_avg_defects = sprintf("%5.1f", mgr_defect_count.to_f / mgr_inspection_count.to_f)
      row = [mgr_name, mgr_avg_defects, mgr_inspection_count.to_i, mgr_defect_count.to_i]
      #logger.info("\n>>>>>>>>>>>>>> row=#{row.inspect}\n")
      @table << row
    end

    @title = "#{@rbuilder.full_name} : Defects by Area Manager for " + date_description(params[:month], start_date, end_date)
  end


  def superintendent_ranking
    start_date = Date.today-1.year
    end_date = Date.today
    @iforms = InspectionForm.find(:all, :conditions => {:idate => start_date..end_date})
  end


  def pdf
    inspection = InspectionForm.find(:first, :conditions => ["slug = ?", params[:id]])
    #logger.info ">>>>>>>>>>>>>> inspection=#{inspection.inspect}"
    if inspection
      @rbuilder = inspection.rbuilder
      @inspector = inspection.inspector
      make_contact_information(@inspector)
      respond_to do |format|
        if inspection.itype == 'FinalInspection'
          @final_inspection = inspection
          format.pdf do
            pdf = FinalInspectionPdf.new(@final_inspection, @inspector, @group_name, @rbuilder, @office, @mobile, @fax)
            send_data pdf.render, :filename => params[:id]+".pdf", :type => "application/pdf", :disposition => "inline"
          end
        elsif inspection.itype == 'FrameInspection'
          @frame_inspection = inspection
          format.pdf do
            pdf = FrameInspectionPdf.new(@frame_inspection, @inspector, @group_name, @rbuilder, @office, @mobile, @fax)
            send_data pdf.render, :filename => params[:id]+".pdf", :type => "application/pdf", :disposition => "inline"
          end
        end
      end
    else
      logger.info(">>>>>>>>>>>>>> NO INSPECTION FOUND slug=#{params[:id]}")
      @title = "Report not found"
    end
  end


  private

  def month_selections
    months = [ ]
    month_dates = { }
    #
    #  this temporary change makes testing with the Grindle data set easier
    #
    start_date = Date.parse("November 1, 2018")  # Date.today.beginning_of_month
    end_date = start_date.end_of_month
    (1..12).each do |index|
      monthname = Date::MONTHNAMES[start_date.month]
      months << monthname
      month_dates[monthname] = [start_date, end_date]

      end_date = start_date.yesterday unless index == 12
      start_date = end_date.beginning_of_month unless index == 12
    end
    months << "Most recent 12 months"
    end_date = Date.today.end_of_month
    start_date = end_date <<(12)
    month_dates["Most recent 12 months"] = [start_date, end_date]

    #logger.info(">>>>>>>>>>>> months=#{months.inspect}")
    #logger.info(">>>>>>>>>>>> month_dates=#{month_dates.inspect}")
    [months, month_dates]
  end

  def date_description( month_selection, start_date, end_date )
    if month_selection.include?("12")
      start_date.strftime("%b %Y through ") + end_date.strftime("%b %Y")
    else
      start_date.strftime("%b %Y")
    end
  end

  def get_actor
    if current_user.is_admin?
      ["rbuilder", Rbuilder.find(params[:builder])] # admin currently chooses a builder
    elsif current_user.is_builder?
      ["rbuilder", Rbuilder.find(current_user.id)]
    elsif current_user.is_superintendent?
      ["superintendent", Superintendent.find(current_user.id)]
    elsif current_user.is_areamanager?
      ["areamanager", Areamanager.find(current_user.id)]
    elsif current_user.is_inspector?
      ["inspector", Inspector.find(current_user.id)]
    else
      [nil, nil]
    end
  end

  def show_dates(month, start_date, end_date)
    if month.include?("12")
      start_date.strftime("%b %Y through ") + end_date.strftime("%b %Y")
    else
      start_date.strftime("%b %Y")
    end
  end
end

