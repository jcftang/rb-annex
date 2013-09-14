require "active_model"
Dir[File.dirname(__FILE__) + '/annex/*.rb'].each do |file|
    require file
end
