class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    begin
      Rails.logger.info '---------------------------------------------------------------------------'
      Rails.logger.info email
      Rails.logger.info '---------------------------------------------------------------------------'
    rescue Exception => e
      puts email
    end
  end
end