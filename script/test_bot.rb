#!/usr/bin/env ruby

# Script to test the bot locally by simulating messages
# Usage: rails runner script/test_bot.rb

class MockTelegramClient
  def api
    self
  end
  
  def send_message(args)
    puts "\n📱 Bot Response:\n"
    puts args[:text]
    true
  end
end

def test_bot_command(bot, chat_id, text)
  puts "\n" + "="*60
  puts "Testing: #{text}"
  puts "="*60

  # Simulate an update
  update_data = {
    message: {
      chat: { id: chat_id },
      text: text
    }
  }

  begin
    bot.process_update(update_data)
    puts "\n✅ Command processed successfully"
  rescue StandardError => e
    puts "\n❌ Error: #{e.message}"
    puts e.backtrace.first(5)
  end
end

puts "🤖 Telegram Quote Bot - Local Test"
puts "="*60

# Set test environment
ENV['TELEGRAM_BOT_TOKEN'] ||= 'test_token_for_local_testing'

# Create bot with mock client
bot = TelegramBot.new
mock_client = MockTelegramClient.new
bot.instance_variable_set(:@client, mock_client)

chat_id = 123456789

commands = [
  '/start',
  '/help',
  '/random',
  '/categories',
  '/quote_Motivation',
  '/quote_Success',
  '/quote_Wisdom',
  '/quote_Courage',
  '/quote_Friendship',
  '/quote_Love',
  'invalid command'
]

commands.each do |cmd|
  test_bot_command(bot, chat_id, cmd)
  sleep 0.3
end

puts "\n" + "="*60
puts "✅ All tests completed!"
puts "="*60
puts "\nSummary:"
puts "- Quote model: #{Quote.count} quotes loaded"
puts "- Categories: #{Quote.all_categories.join(', ')}"
puts "- Bot service: Ready to deploy!"
