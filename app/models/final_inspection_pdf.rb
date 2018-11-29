class FinalInspectionPdf < Prawn::Document
 
  def initialize( final_inspection, inspector, group_name, rbuilder, office, mobile, fax )
    super()

    bounding_box [0,730], :width => 400 do
      text "Inspected by:  #{inspector.full_name}", :size => 10
    end

    bounding_box [400,730], :width => 200 do
      text "Job Number:  #{final_inspection.jobnumber}", :size => 10
    end

    bounding_box [0,715], :width => 540 do
      text group_name, :size => 25, :align => :center
      move_down(0)
      text "Office: " + office, :size => 10, :align => :center
      text "Mobile: " + mobile, :size => 10, :align => :center
      text "Fax: "    + fax,    :size => 10, :align => :center
    end

    bounding_box [1,640], :width => 200 do
      text "Builder:  #{rbuilder.full_name}", :size => 10
    end

    bounding_box [200,640], :width => 200 do
      text "Inspection Type: Final", :size => 10
    end

    bounding_box [400,640], :width => 200 do
      text "Date:  #{final_inspection.idate.strftime('%b %d, %Y')}", :size => 10
    end

    bounding_box [1,620], :width => 200 do
      text "Address:  #{final_inspection.address}", :size => 10
    end

    bounding_box [200,620], :width => 200 do
      text "City:  #{final_inspection.city.capitalize}", :size => 10
    end

    bounding_box [400,620], :width => 200 do
      text "State:  #{final_inspection.state.capitalize}", :size => 10
    end

    bounding_box [1,600], :width => 200 do
      text "Subdivision:  #{final_inspection.subdivision.name}", :size => 10
    end

    bounding_box [200,600], :width => 200 do
      text "Area Manager:  #{final_inspection.areamanager.full_name}", :size => 10
    end

    bounding_box [400,600], :width => 200 do
      text "Superintendent:  #{final_inspection.superintendent.full_name}", :size => 10
    end

    bounding_box [1,580], :width => 200 do
      text "Passed:  #{final_inspection.passed? ? 'Yes' : 'No'}", :size => 11, :style => :bold
    end

    bounding_box [200,580], :width => 200 do
      text "Reinspection Required:  #{final_inspection.rinpreq? ? 'Yes' : 'No'}", :size => 11, :style => :bold
    end

    bounding_box [400,580], :width => 200 do
      text "Correct & Proceed: #{final_inspection.corpro? ? 'Yes' : 'No'}", :size => 11, :style => :bold
    end

    bounding_box [1,560], :width => 100 do
      text "House Clean:  #{final_inspection.houseclean? ? 'Yes' : 'No'}", :size => 10
    end

    bounding_box [130,560], :width => 100 do
      text "Electric Meter:  #{final_inspection.elcmeter? ? 'Yes' : 'No'}", :size => 10
    end

    bounding_box [260,560], :width => 100 do
      text "Gas Meter:  #{final_inspection.gasmeter? ? 'Yes' : 'No'}", :size => 10
    end

    bounding_box [400,560], :width => 100 do
      text "Appliances:  #{final_inspection.appliances? ? 'Yes' : 'No'}", :size => 10
    end

    move_down(18)
    text "Final Grade", :size => 15, :align => :center
    bounding_box [1, 500], :width => 100 do
      text "Passed: #{final_inspection.fgpass? ? 'Yes' : 'No'}", :size => 10
    end

    bounding_box [200,500], :width => 200 do
      text "Correct & Proceed: #{final_inspection.fgcap? ? 'Yes' : 'No'}", :size => 10
    end

    bounding_box [400, 500], :width => 200 do
      text "Call for Reinspection: #{final_inspection.fgcfr? ? 'Yes' : 'No'}", :size => 10
    end

    move_down(20)

    if final_inspection.defects.count > 0 then
      defects = [["Trade", "Defect"]]
      final_inspection.defects.each do |defect|
        defects << [defect.category.name, defect.name]
      end
      text "Problem Areas", :size => 14
      table defects, :header => true, :row_colors => ["DDDDDD", "FFFFFF"], :cell_style => { :size => 10 }
      move_down(10)
      text "Total Defects  #{final_inspection.defects.count}", :size => 12, :style => :bold
    else
      text "No Problem areas"
    end

    if final_inspection.comments.count > 0 then
      move_down(15)
      comments = [["Type", "Comment"]]
      final_inspection.comments.each do |comm|
        comments << ["Comment:", comm.info]
      end
      text "Comments", :size => 15
      table comments, :header => true, :row_colors => ["DDDDDD", "FFFFFF"], :cell_style => { :size => 10 }
      move_down(10)
    else
      text "No Comments"
    end

    Rails.logger.info ">>>>> rbuilder=#{rbuilder.inspect}"

    text " "
    text " "
    if rbuilder.is_drhorton?
      text "Home meets IRC standards.                                                            Date"
      text " "
      text "______________________________________                             _______________"
      text "Inspector"
    else
      text "All items have been completed to our satisfaction.                            Date"
      text " "
      text "______________________________________                             _______________"
      text "Buyer"
    end

  end

end