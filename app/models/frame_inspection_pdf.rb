class FrameInspectionPdf < Prawn::Document

  def initialize( frame_inspection, inspector, group_name, rbuilder, office, mobile, fax )
    super()

    bounding_box [0,730], :width => 400 do
      text "Inspected by:  #{frame_inspection.inspector.full_name}", :size => 10
    end

    bounding_box [400,730], :width => 200 do
      text "Job Number:  #{frame_inspection.jobnumber}", :size => 10
    end

    bounding_box [0,715], :width => 540 do
      text group_name, :size => 25, :align => :center
      move_down(0)
      text "Office: " + office, :size => 10, :align => :center
      text "Mobile: " + mobile, :size => 10, :align => :center
      text "Fax: "    + fax,    :size => 10, :align => :center
    end

    move_down(160)
    bounding_box [1,640], :width => 200 do
      text "Builder:  #{rbuilder.full_name}", :size => 10
    end

    bounding_box [200,640], :width => 200 do
      text "Inspection Type: Frame", :size => 10
    end

    bounding_box [400,640], :width => 200 do
      text "Date:  #{frame_inspection.idate.strftime('%b %d, %Y')}", :size => 10
    end

    bounding_box [1,620], :width => 200 do
      text "Address:  #{frame_inspection.address}", :size => 10
    end

    bounding_box [200,620], :width => 200 do
      text "City:  #{frame_inspection.city.capitalize}", :size => 10
    end

    bounding_box [400,620], :width => 200 do
      text "State:  #{frame_inspection.state.capitalize}", :size => 10
    end

    bounding_box [1,600], :width => 200 do
      text "Subdivision:  #{frame_inspection.subdivision.name}", :size => 10
    end

    bounding_box [200,600], :width => 200 do
      text "Area Manager:  #{frame_inspection.areamanager.full_name}", :size => 10
    end

    bounding_box [400,600], :width => 200 do
      text "Superintendent:  #{frame_inspection.superintendent.full_name}", :size => 10
    end

    bounding_box [1,580], :width => 200 do
      text "Passed:  #{frame_inspection.passed? ? 'Yes' : 'No'}", :size => 10
    end

    bounding_box [200,580], :width => 200 do
      text "Reinspection Required:  #{frame_inspection.rinpreq? ? 'Yes' : 'No'}", :size => 10
    end

    bounding_box [400,580], :width => 200 do
      text "Correct & Proceed: #{frame_inspection.corpro? ? 'Yes' : 'No'}", :size => 10
    end

    bounding_box [1,560], :width => 200 do
      text "Ok to sheet rock?:  #{frame_inspection.otsr? ? 'Yes' : 'No'}", :size => 10
    end

    bounding_box [200,560], :width => 200 do
      text "Ok to insulate?:  #{frame_inspection.oti? ? 'Yes' : 'No'}", :size => 10
    end

    bounding_box [400,560], :width => 200 do
      text "Ok to brick:  #{frame_inspection.otb? ? 'Yes' : 'No'}", :size => 10
    end

    move_down(20)

    if frame_inspection.defects.count > 0 then
      defects = [["Trade", "Defect"]]
      frame_inspection.defects.each do |defect|
        defects << [defect.category.name, defect.name]
      end
      text "Problem Areas", :size => 15
      table defects, :header => true, :row_colors => ["DDDDDD", "FFFFFF"], :cell_style => { :size => 10 }
      move_down(10)
      text "Total Defects  #{frame_inspection.defects.count}", :size => 12, :style => :bold
    else
      text "No Problem areas"
    end

    if frame_inspection.comments.count > 0 then
      move_down(15)
      comments = [["Type", "Comment"]]
      frame_inspection.comments.each do |comm|
        comments << ["Comment:", comm.info]
      end
      text "Comments", :size => 15
      table comments, :header => true, :row_colors => ["DDDDDD", "FFFFFF"], :cell_style => { :size => 10 }
      move_down(10)
    else
      text "No Comments"
    end

  end

end
