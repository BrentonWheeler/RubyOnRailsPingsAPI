class Ping < ApplicationRecord
    validates :device_id, presence: true
    validates :epoch_time, presence: true
end
