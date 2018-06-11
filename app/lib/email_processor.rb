class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    begin
      Rails.logger.info '---------------------------------------------------------------------------'
      Rails.logger.info @email.inspect
      Rails.logger.info '---------------------------------------------------------------------------'
    rescue Exception => e
      puts 'EXCEPTION'
      puts @email.inspect
    end
  end
end