class TelegramWebhookController < ApplicationController
  skip_forgery_protection

  def update
    bot = TelegramBot.new
    bot.process_update(request.parameters)
    head :ok
  end
end
