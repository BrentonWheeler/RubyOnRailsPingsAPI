Rails.application.routes.draw do
    post '/clear_data' => 'pings#clearData'
    get '/devices' => 'pings#getDevices'
    post '/:device_id/:epoch_time' => 'pings#storePing'
    get '/:deviceID/:date' => 'pings#getPingsForOneDate'
    get '/:deviceID/:from/:to' => 'pings#getPingsBetweenTwoDateTimes'
end
