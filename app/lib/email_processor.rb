class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    begin
      exec("/bin/sh /home/moto/apps/brimir/current/script/post-mail http://tickets.mesbesoinsmoto.com/tickets.json")
      Rails.logger.info '---------------------------------------------------------------------------'
      Rails.logger.info @email.inspect
      Rails.logger.info '---------------------------------------------------------------------------'
    rescue Exception => e
      puts 'EXCEPTION'
      puts @email.inspect
    end
  end
end