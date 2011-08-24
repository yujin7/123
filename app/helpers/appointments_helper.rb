module AppointmentsHelper

  def appointment_exists?(data_hash, staff, hour, stage)
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    appointment_exists = false
    appointment_details = ''
    appointment_id = nil
    puts staff.to_s+'_'+hour.to_s+'_'+stage.to_s
    if data_hash.keys.include?(staff.to_s+'_'+hour.to_s+'_'+stage.to_s)
      entry = data_hash[staff.to_s+'_'+hour.to_s+'_'+stage.to_s]
      stage_level_in = (0..15).include?(entry[2].to_datetime.minute) ? 1 : ((16..30).include?(entry[2].to_datetime.minute) ? 2 : ((31..45).include?(entry[2].to_datetime.minute) ? 3 : ((45..59).include?(entry[2].to_datetime.minute) ? 4 : 5)))
      stage_level_out = (0..15).include?(entry[3].to_datetime.minute) ? 1 : ((16..30).include?(entry[3].to_datetime.minute) ? 2 : ((31..45).include?(entry[3].to_datetime.minute) ? 3 : ((45..59).include?(entry[3].to_datetime.minute) ? 4 : 5)))
      if (entry[2].to_datetime.hour == hour or entry[3].to_datetime.hour == hour ) or (stage_level_in == stage or stage_level_out == stage )
        puts "?????????????????????????????"
        appointment_exists = true
        appointment_details = entry[1]
        appointment_id = entry[0]
      end
    end
    return appointment_exists, appointment_id, appointment_details
  end

end
