module ReportsHelper

  def get_inspection_average(obj, itype)
    insp_total = itype == "FinalInspection" ? obj.final_inspections.count : obj.frame_inspections.count
    comm_total = obj.defects.count(:conditions => ["itype = ?", itype])
    total = sprintf("%5.1f\n", comm_total.to_f / insp_total.to_f)
    total = '--' if total.include? 'nan'
    return total
  end

end

