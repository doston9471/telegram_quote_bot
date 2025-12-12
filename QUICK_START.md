# Quick Start Guide - Telegram Quote Bot

## 5-Minute Setup

### 1. Install Dependencies
```bash
bundle install
```

### 2. Create Database
```bash
rails db:create db:migrate db:seed
```

### 3. Get Your Bot Token
- Open Telegram and search for **@BotFather**
- Send `/newbot`
- Follow prompts and copy the bot token

### 4. Configure Environment
```bash
cp .env.example .env
# Edit .env and paste your bot token as TELEGRAM_BOT_TOKEN
```

### 5. Test Locally
```bash
rails runner script/test_bot.rb
```

### 6. Deploy & Register Webhook

Once your app is publicly accessible via HTTPS (e.g., on Heroku):

```bash
export TELEGRAM_BOT_TOKEN=your_token_here
export TELEGRAM_BOT_WEBHOOK_URL=https://your-app-url.com/telegram/webhook
rails telegram:set_webhook
```

That's it! Your bot is now running on Telegram.

## Available Commands

Users can send these commands to your bot:

- `/start` - Welcome message
- `/help` - List all commands
- `/random` - Get a random quote
- `/categories` - List all quote categories
- `/quote_Motivation` - Get a motivation quote
- `/quote_Success` - Get a success quote
- `/quote_Wisdom` - Get a wisdom quote
- `/quote_Courage` - Get a courage quote
- `/quote_Friendship` - Get a friendship quote
- `/quote_Love` - Get a love quote

## Project Structure

```
├── app/
│   ├── models/quote.rb           # Quote model
│   ├── controllers/              # Webhook receiver
│   └── services/telegram_bot.rb  # Bot logic
├── db/seeds.rb                   # Quote data (21 quotes)
├── lib/tasks/telegram.rake       # Webhook management tasks
├── script/test_bot.rb            # Local testing script
└── config/
    └── routes.rb                 # Webhook route: POST /telegram/webhook
```

## Adding More Quotes

Edit `db/seeds.rb` and add new quotes:

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

**Bot not responding?**
```bash
rails telegram:webhook_info
```

**Test locally without deploying?**
```bash
rails runner script/test_bot.rb
```

**Reset everything?**
```bash
rails db:drop db:create db:migrate db:seed
rails telegram:set_webhook
```

## Next Steps

- Add more quotes to `db/seeds.rb`
- Deploy to Heroku, AWS, or your own server
- Add more bot commands
- Implement persistent user data
- Add scheduling for "Quote of the Day"

See `TELEGRAM_BOT_SETUP.md` for detailed deployment instructions.
