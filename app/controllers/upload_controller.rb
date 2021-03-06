class UploadController < ApplicationController

  def index
  end

  def import
    file = params[:file]
    lineNum = 0
    alert = []

    if file == nil
      alert << "select file to upload"
      redirect_to upload_index_path, alert: alert
    else
      #send to a "sort" method that uploads drivers and records
      alert = []
      File.foreach(file).each do |line|
        lineNum += 1
        arr = line.split(' ')

        case arr[0]
        when "Driver"
          if arr.length == 2
            driver = Driver.create({
              name: arr[1]
            })
            if driver.errors.any?
              alert += driver.errors.full_messages.map do |error|
                error + " - line #{lineNum} #{line}" 
              end
            end
          else
            alert << "Not 2 args Driver error with line - line #{lineNum} #{line}" 
          end

        when "Trip"
          if arr.length == 5
            record = DrivingRecord.create({
              driver: Driver.find_by(name: arr[1]),
              start_time: arr[2],
              end_time: arr[3],
              miles_driven: arr[4]
            })
            if record.errors.any?
              alert += record.errors.full_messages.map do |error|
                error + " - line #{lineNum} #{line}" 
              end
            end
          else
            alert << "Not 4 args Trip error with line - line #{lineNum} #{line}" 
          end

        else
          alert << "Missing keyword Trip/Driver for - line #{lineNum} #{line}" 
        end


      end
      redirect_to drivers_path, notice: "import processed", alert: alert
    end
  end
end