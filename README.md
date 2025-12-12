# Telegram Quote Bot

A Ruby on Rails application that implements a Telegram bot for sharing inspiring quotes with users.

## Quick Start

### 1. Install Dependencies
```bash
bundle install
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env and add your TELEGRAM_BOT_TOKEN
```

### 3. Set Up Database
```bash
rails db:create
rails db:migrate
rails db:seed
```

### 4. Run the Server
```bash
./bin/dev
```

### 5. Register Webhook with Telegram
```bash
rails telegram:set_webhook
```

## Features

- 🎯 **Random Quotes**: Get inspirational quotes with one command
- 📂 **Categories**: Browse quotes by category (Motivation, Success, Wisdom, etc.)
- ⚡ **Fast & Responsive**: Instant responses via webhook
- 💾 **SQLite Database**: 21+ curated quotes included
- 🛠️ **Easy to Extend**: Simple architecture for adding more quotes

## Bot Commands

- `/start` - Welcome message
- `/random` - Get a random quote
- `/categories` - List all categories
- `/quote_Motivation` - Get a Motivation quote
- `/quote_Success` - Get a Success quote
- `/quote_Wisdom` - Get a Wisdom quote
- `/quote_Courage` - Get a Courage quote
- `/quote_Friendship` - Get a Friendship quote
- `/quote_Love` - Get a Love quote
- `/help` - Show all available commands

## Detailed Setup Guide

See [TELEGRAM_BOT_SETUP.md](TELEGRAM_BOT_SETUP.md) for detailed setup instructions including:
- Getting a Telegram bot token
- Webhook configuration
- Deployment options (Heroku, Docker)
- Troubleshooting

## Project Structure

```
telegram_quote_bot/
├── app/
│   ├── models/
│   │   └── quote.rb              # Quote model with validations
│   ├── controllers/
│   │   └── telegram_webhook_controller.rb  # Webhook receiver
│   └── services/
│       └── telegram_bot.rb       # Bot logic and command handlers
├── db/
│   ├── migrate/                  # Database migrations
│   └── seeds.rb                  # Quote seed data
├── lib/tasks/
│   └── telegram.rake             # Webhook management tasks
├── script/
│   └── test_bot.rb               # Local bot testing script
└── config/
    └── routes.rb                 # Webhook route
```

## Technology Stack

- **Rails**: Web framework
- **SQLite3**: Database
- **telegram-bot-ruby**: Telegram Bot API client
- **dotenv-rails**: Environment variable management

## Development

### Test the Bot Locally
```bash
ruby script/test_bot.rb
```

### Rake Tasks
```bash
# Set webhook
rails telegram:set_webhook

# Get webhook info
rails telegram:webhook_info

# Delete webhook
rails telegram:delete_webhook
```

### Access Rails Console
```bash
rails console

# Try some commands
Quote.random_quote
Quote.all_categories
Quote.by_category('Motivation')
```

## Deployment

### Heroku
1. Create Heroku app
2. Set environment variables: `TELEGRAM_BOT_TOKEN`, `TELEGRAM_BOT_WEBHOOK_URL`
3. Deploy with git
4. Run migrations
5. Set webhook with rake task

See [TELEGRAM_BOT_SETUP.md](TELEGRAM_BOT_SETUP.md#heroku) for detailed instructions.

### Docker
```bash
docker build -t telegram-quote-bot .
docker run -e TELEGRAM_BOT_TOKEN=your_token -p 3000:3000 telegram-quote-bot
```

## Adding More Quotes

Edit `db/seeds.rb` and add quotes to the array:
```ruby
Quote.create!(
  text: "Your quote here",
  author: "Author Name",
  category: "Category Name"
)
```

Then run:
```bash
rails db:seed
```

## Troubleshooting

**Bot doesn't respond?**
- Check `.env` has correct `TELEGRAM_BOT_TOKEN`
- Verify webhook is set: `rails telegram:webhook_info`
- Ensure your server is publicly accessible via HTTPS

**Database issues?**
```bash
rails db:drop db:create db:migrate db:seed
```

## License

MIT License - feel free to use for your own projects!

## Support

For issues or questions, check the [detailed setup guide](TELEGRAM_BOT_SETUP.md) or review the code comments.
