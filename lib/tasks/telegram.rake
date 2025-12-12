namespace :telegram do
  desc "Set webhook for Telegram bot"
  task set_webhook: :environment do
    require 'telegram/bot'
    
    token = ENV['TELEGRAM_BOT_TOKEN']
    webhook_url = ENV['TELEGRAM_BOT_WEBHOOK_URL']

    unless token && webhook_url
      puts "❌ Error: TELEGRAM_BOT_TOKEN and TELEGRAM_BOT_WEBHOOK_URL must be set in .env"
      exit 1
    end

    client = ::Telegram::Bot::Client.new(token)

    begin
      response = client.api.set_webhook(url: webhook_url)
      if response
        puts "✅ Webhook set successfully!"
        puts "   URL: #{webhook_url}"
        puts "\n📊 Webhook is now registered and ready to receive messages!"
        puts "\n💡 Test your bot by sending a message in Telegram"
        puts "   Check logs with: tail -f log/development.log"
      else
        puts "❌ Failed to set webhook"
      end
    rescue StandardError => e
      puts "❌ Error: #{e.message}"
      puts "\nTroubleshooting:"
      puts "  • Check that TELEGRAM_BOT_TOKEN is correct"
      puts "  • Ensure TELEGRAM_BOT_WEBHOOK_URL uses HTTPS"
      puts "  • Verify the URL is accessible from the internet"
      puts "  • Use ports: 80, 88, 443, or 8443"
      exit 1
    end
  end

  desc "Get Telegram webhook info"
  task webhook_info: :environment do
    token = ENV['TELEGRAM_BOT_TOKEN']
    webhook_url = ENV['TELEGRAM_BOT_WEBHOOK_URL']

    unless token
      puts "❌ Error: TELEGRAM_BOT_TOKEN must be set in .env"
      exit 1
    end

    puts "📊 Webhook Configuration:"
    puts "   Token: #{token[0..10]}..." if token.length > 10
    puts "   Webhook URL: #{webhook_url || '(not configured)'}"
    
    puts "\n✅ To register the webhook, run:"
    puts "   rails telegram:set_webhook"
    puts "\n✅ You can also verify via curl:"
    puts "   curl https://api.telegram.org/bot#{token[0..10]}...XXXX/getWebhookInfo"
  end

  desc "Delete Telegram webhook"
  task delete_webhook: :environment do
    require 'telegram/bot'
    
    token = ENV['TELEGRAM_BOT_TOKEN']

    unless token
      puts "❌ Error: TELEGRAM_BOT_TOKEN must be set in .env"
      exit 1
    end

    client = ::Telegram::Bot::Client.new(token)

    begin
      response = client.api.delete_webhook
      if response
        puts "✅ Webhook deleted successfully"
      else
        puts "❌ Failed to delete webhook"
      end
    rescue StandardError => e
      puts "❌ Error: #{e.message}"
      exit 1
    end
  end
end
