class UserSession < Authlogic::Session::Base
  #  require 'net/http'
  #  require 'net/https'
  #  require 'openssl'

  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

  #  def self.bandwidth
  #
  #    url = URI.parse("https://prtg.gnax.net")
  #    http = Net::HTTP.new(url.host, 443)
  #    http.use_ssl = true
  #    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  #
  #    req = Net::HTTP::Get.new("/api/historicdata.xml?id=4514&avg=3600&sdate=2011-03-14-00-00-00&edate=2011-03-14-24-00-00&username=carmatec&passhash=4253619735")
  ##    req.set_form_data({"id" => "4514", "avg" => "3600", "sdate" => "2011-03-14-00-00-00", "edate" => "2011-03-14-24-00-00", "username" => "carmatec", "passhash" => "4253619735"})
  #    response = http.request(req)
  #    puts response.inspect
  #    puts response.body
  #    return response.body
  #  end
end