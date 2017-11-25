class PingsController < ApplicationController

    SECONDS_IN_A_DAY = 86400

    def clearData
        Ping.delete_all
        render status: :ok
    end

    def getDevices
        devices = Ping.distinct.pluck(:device_id)
        devices = devices.as_json
        render json: devices, status: :ok
    end

    def storePing
        ping = Ping.new(ping_params)

        if ping.save
            render json: [], status: :ok
        else
            render json: [], status: :unprocessable_entity
        end
    end

    # Get pings for one ISO date
    def getPingsForOneDate
        parsedDate = params[:date].split("-")
        startEpochTime = Time.utc(parsedDate[0], parsedDate[1], parsedDate[2]).to_i
        endEpochTime = startEpochTime + SECONDS_IN_A_DAY

        # GET pings for "all" in device_id param
        if params[:deviceID] == "all"
            pings = Ping.where("epoch_time >= ? AND epoch_time < ?", startEpochTime, endEpochTime)
            pingsJSON = {}

            pings.each do |ping|
                if !pingsJSON.key?(ping[:device_id])
                    pingsJSON[ping[:device_id]] = Array.new
                end
                pingsJSON[ping[:device_id]].push(ping[:epoch_time])

            end
            
            render json: pingsJSON, status: :ok
        # GET pings for a device ID in device_id param
        else 
            pings = Ping.where("device_id = ? AND epoch_time >= ? AND epoch_time < ?", params[:deviceID], startEpochTime, endEpochTime)
            pingsArray = []

            pings.each do |ping|
                pingsArray.push(ping[:epoch_time])
            end
            
            render json: pingsArray, status: :ok
        end
    end

    # Get pings between two ISO dates or epoch times
    def getPingsBetweenTwoDateTimes
        startEpochTime = params[:from]
        endEpochTime = params[:to]

        if startEpochTime.include?("-")
            parsedDate = params[:from].split("-")
            startEpochTime = Time.utc(parsedDate[0], parsedDate[1], parsedDate[2]).to_i
        end 
        if endEpochTime.include?("-")
            parsedDate = params[:to].split("-")
            endEpochTime = Time.utc(parsedDate[0], parsedDate[1], parsedDate[2]).to_i
        end 

        # GET pings for a "all" in device_id param
        if params[:deviceID] == "all"
            pings = Ping.where("epoch_time >= ? AND epoch_time < ?", startEpochTime, endEpochTime)
            pingsJSON = {}

            pings.each do |ping|
                if !pingsJSON.key?(ping[:device_id])
                    pingsJSON[ping[:device_id]] = Array.new
                end
                pingsJSON[ping[:device_id]].push(ping[:epoch_time])
            end
            
            render json: pingsJSON, status: :ok
        # GET pings for a device ID in device_id param
        else 
            pings = Ping.where("device_id = ? AND epoch_time >= ? AND epoch_time < ?", params[:deviceID], startEpochTime, endEpochTime)
            pingsArray = []

            pings.each do |ping|
                pingsArray.push(ping[:epoch_time])
            end
            
            render json: pingsArray, status: :ok
        end
    end

    private
    def ping_params
        params.permit(:device_id, :epoch_time)
    end
end