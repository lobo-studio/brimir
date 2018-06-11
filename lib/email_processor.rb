class EmailProcessor
  def self.process(email)
    begin
      Rails.logger.info '---------------------------------------------------------------------------'
      Rails.logger.info email
      Rails.logger.info '---------------------------------------------------------------------------'
    rescue Exception => e
      puts email
    end

  end
end