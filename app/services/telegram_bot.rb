class TelegramBot
  def initialize
    @token = ENV['TELEGRAM_BOT_TOKEN']
    begin
      require 'telegram/bot'
      @client = ::Telegram::Bot::Client.new(@token) if @token
    rescue LoadError => e
      Rails.logger.warn("Telegram gem not properly loaded: #{e.message}")
      @client = nil
    end
  end

  def process_update(update)
    # Handle the update as a hash or object
    message = extract_message(update)
    return unless message

    chat_id = extract_chat_id(message)
    text = extract_text(message)

    handle_command(chat_id, text) if text
  rescue StandardError => e
    Rails.logger.error("Telegram bot error: #{e.message}\n#{e.backtrace.join("\n")}")
  end

  private

  def extract_message(update)
    if update.respond_to?(:message)
      update.message
    elsif update.is_a?(Hash) && update['message']
      update['message']
    elsif update.is_a?(Hash) && update[:message]
      update[:message]
    end
  end

  def extract_chat_id(message)
    if message.respond_to?(:chat)
      message.chat.id
    elsif message.is_a?(Hash) && message['chat']
      message['chat']['id'] || message['chat'][:id]
    elsif message.is_a?(Hash) && message[:chat]
      message[:chat][:id]
    end
  end

  def extract_text(message)
    if message.respond_to?(:text)
      message.text
    elsif message.is_a?(Hash) && message['text']
      message['text']
    elsif message.is_a?(Hash) && message[:text]
      message[:text]
    end
  end

  def handle_command(chat_id, text)
    if text == '/start'
      send_start_message(chat_id)
    elsif text == '/random'
      send_random_quote(chat_id)
    elsif text == '/categories'
      send_categories_list(chat_id)
    elsif text == '/help'
      send_help_message(chat_id)
    elsif text.match?(%r{^/quote_})
      category = text.sub('/quote_', '')
      send_quote_by_category(chat_id, category)
    else
      send_message(chat_id, "❓ Unknown command. Type /help to see available commands.")
    end
  end

  def send_start_message(chat_id)
    message = <<~MSG
      👋 Welcome to the Quote Bot!

      I share inspiring quotes from great thinkers and leaders.

      Type /help to see available commands.
    MSG
    send_message(chat_id, message)
  end

  def send_help_message(chat_id)
    categories = Quote.all_categories.join(", ")
    message = <<~MSG
      📚 Available Commands:
      
      /random - Get a random quote
      /categories - Show all quote categories
      /quote_Motivation - Get a quote from the Motivation category
      /quote_Success - Get a quote from the Success category
      /quote_Wisdom - Get a quote from the Wisdom category
      /quote_Courage - Get a quote from the Courage category
      /quote_Friendship - Get a quote from the Friendship category
      /quote_Love - Get a quote from the Love category
      /help - Show this help message
      
      Available categories: #{categories}
    MSG
    send_message(chat_id, message)
  end

  def send_random_quote(chat_id)
    quote = Quote.random_quote
    if quote
      message = format_quote(quote)
      send_message(chat_id, message)
    else
      send_message(chat_id, "No quotes available at the moment.")
    end
  end

  def send_categories_list(chat_id)
    categories = Quote.all_categories
    if categories.any?
      message = "📂 Available Categories:\n\n"
      categories.each do |category|
        count = Quote.by_category(category).count
        message += "• #{category} (#{count} quotes)\n"
      end
      send_message(chat_id, message)
    else
      send_message(chat_id, "No categories available.")
    end
  end

  def send_quote_by_category(chat_id, category)
    quotes = Quote.by_category(category)
    if quotes.any?
      quote = quotes.order("RANDOM()").first
      message = format_quote(quote)
      send_message(chat_id, message)
    else
      send_message(chat_id, "❌ No quotes found in the '#{category}' category.")
    end
  end

  def format_quote(quote)
    <<~QUOTE
      "#{quote.text}"
      
      — #{quote.author}
      
      📂 Category: #{quote.category}
    QUOTE
  end

  def send_message(chat_id, text)
    @client.api.send_message(
      chat_id: chat_id,
      text: text,
      parse_mode: 'HTML'
    )
  rescue StandardError => e
    Rails.logger.error("Failed to send message: #{e.message}")
  end
end
