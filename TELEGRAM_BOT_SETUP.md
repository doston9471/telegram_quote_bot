# Telegram Quote Bot

A Ruby on Rails bot that shares inspiring quotes with users via Telegram. The bot supports various quote categories and provides both random quotes and category-specific quotes.

## Features

- 📚 **Quote Database**: 21+ curated quotes across 6 categories (Motivation, Success, Wisdom, Courage, Friendship, Love)
- 🎲 **Random Quotes**: Get a random quote with a single command
- 📂 **Categories**: Browse quotes by category
- 🔍 **Search by Category**: Get quotes from specific categories
- ✨ **Simple Commands**: Easy-to-use command interface

## Setup Instructions

### Prerequisites

- Ruby 3.0 or higher
- Rails 8.0+
- SQLite3
- A Telegram Bot Token (from BotFather)

### 1. Clone and Install Dependencies

```bash
cd telegram_quote_bot
bundle install
```

### 2. Set Up Environment Variables

```bash
cp .env.example .env
```

Edit `.env` and add your Telegram bot token:

```
TELEGRAM_BOT_TOKEN=your_actual_bot_token_here
TELEGRAM_BOT_WEBHOOK_URL=https://yourdomain.com/telegram/webhook
```

### 3. Set Up Database

```bash
rails db:create
rails db:migrate
rails db:seed
```

This will create the database and seed it with 21 quotes across different categories.

### 4. Get Your Telegram Bot Token

1. Open Telegram and search for **@BotFather**
2. Send `/newbot` command
3. Follow the prompts to create a new bot
4. Copy the bot token provided
5. Add it to your `.env` file as `TELEGRAM_BOT_TOKEN`

### 5. Register Webhook with Telegram

Once your Rails app is deployed and accessible via HTTPS on ports 80, 88, 443, or 8443, register the webhook:

**Step 1: Update your .env file with your actual domain**

```bash
# Before deploying, update this to your actual domain:
TELEGRAM_BOT_WEBHOOK_URL=https://yourdomain.com/telegram/webhook
```

**Step 2: Register the webhook using the Rake task (Recommended)**

```bash
rails telegram:set_webhook
```

This automatically reads from your `.env` file and registers the webhook.

**Check webhook status:**

```bash
rails telegram:webhook_info
```

**Alternative: Using curl directly**

If you prefer to use curl:

```bash
curl -X POST https://api.telegram.org/bot{YOUR_BOT_TOKEN}/setWebhook \
  -d url=https://yourdomain.com/telegram/webhook
```

Replace `{YOUR_BOT_TOKEN}` with your actual token and `yourdomain.com` with your domain.

Verify with:

```bash
curl https://api.telegram.org/bot{YOUR_BOT_TOKEN}/getWebhookInfo
```

**Important Notes:**
- The webhook URL **must use HTTPS** and a valid SSL certificate
- Telegram only accepts ports: **80, 88, 443, or 8443**
- The domain must be publicly accessible from the internet
- For local development, use ngrok to tunnel your local server

### 6. Run the Server

```bash
./bin/dev
```

or

```bash
rails server -p 3000
```

## Bot Commands

Users can interact with the bot using these commands:

| Command | Description |
|---------|-------------|
| `/start` | Welcome message and introduction |
| `/random` | Get a random quote |
| `/categories` | List all available categories with quote counts |
| `/quote_Motivation` | Get a random quote from Motivation category |
| `/quote_Success` | Get a random quote from Success category |
| `/quote_Wisdom` | Get a random quote from Wisdom category |
| `/quote_Courage` | Get a random quote from Courage category |
| `/quote_Friendship` | Get a random quote from Friendship category |
| `/quote_Love` | Get a random quote from Love category |
| `/help` | Show detailed help message |

## Database Schema

### Quotes Table

| Column | Type | Description |
|--------|------|-------------|
| id | Integer | Primary key |
| text | Text | The quote text |
| author | String | Author of the quote |
| category | String | Category (Motivation, Success, Wisdom, etc.) |
| created_at | DateTime | Creation timestamp |
| updated_at | DateTime | Update timestamp |

## Adding More Quotes

To add more quotes, edit `db/seeds.rb` and add them to the quotes array:

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

## Architecture

### Key Components

1. **Quote Model** (`app/models/quote.rb`)
   - Validates quote attributes
   - Provides scopes for filtering by category
   - Includes helper methods for random quotes and categories list

2. **TelegramBot Service** (`app/services/telegram_bot.rb`)
   - Handles all bot logic
   - Processes incoming messages
   - Routes commands to appropriate handlers
   - Formats and sends responses

3. **TelegramWebhookController** (`app/controllers/telegram_webhook_controller.rb`)
   - Receives Telegram updates via webhook
   - Delegates to TelegramBot service
   - Responds with 200 OK

4. **Gems**
   - `telegram-bot-ruby`: Telegram Bot API client
   - `dotenv-rails`: Environment variable management

## Deployment

### Heroku

1. Create a Heroku app:
   ```bash
   heroku create your-quote-bot
   ```

2. Set environment variables:
   ```bash
   heroku config:set TELEGRAM_BOT_TOKEN=your_token
   heroku config:set TELEGRAM_BOT_WEBHOOK_URL=https://your-quote-bot.herokuapp.com/telegram/webhook
   ```

3. Push your code:
   ```bash
   git push heroku main
   ```

4. Run migrations:
   ```bash
   heroku run rails db:migrate
   heroku run rails db:seed
   ```

5. Set the webhook:
   ```bash
   heroku run rails telegram:set_webhook
   ```
   
   Or verify it was set:
   ```bash
   heroku run rails telegram:webhook_info
   ```

### Docker

A Dockerfile is included. Build and run:

```bash
docker build -t telegram-quote-bot .
docker run -e TELEGRAM_BOT_TOKEN=your_token -p 3000:3000 telegram-quote-bot
```

## Development

To run in development with automatic reload:

```bash
./bin/dev
```

### Testing webhook locally with ngrok

For local development, you can use ngrok to expose your local Rails server to the internet:

**1. Install ngrok:**

```bash
brew install ngrok
# or download from https://ngrok.com
```

**2. Start ngrok (in a separate terminal):**

```bash
ngrok http 3000
```

This will output something like: `https://abc123.ngrok.io`

**3. Update your .env:**

```bash
TELEGRAM_BOT_WEBHOOK_URL=https://abc123.ngrok.io/telegram/webhook
```

**4. Register the webhook:**

```bash
rails telegram:set_webhook
```

**5. Test the bot:**

Send commands to your bot in Telegram - they should now be received by your local Rails server!

Check the logs with: `tail -f log/development.log`

## Troubleshooting

### Bot doesn't respond

1. Check that the bot token is correct in `.env`
2. Verify the webhook URL is accessible from the internet (HTTPS required)
3. Check Rails logs: `tail -f log/development.log`
4. Verify webhook is registered: 
   ```bash
   rails telegram:webhook_info
   ```
5. If using ngrok, make sure it's still running and the tunnel is active

### Webhook registration fails

**Error: "bad webhook: Webhook can be set up only on ports 80, 88, 443 or 8443"**

- Your webhook URL must be on one of these ports (HTTPS port 443 is recommended)
- For local dev with ngrok, ngrok typically uses 443 automatically
- For production, ensure your domain/server uses port 443

**Error: SSL certificate issues**

- Ensure your domain has a valid, trusted SSL certificate
- Telegram requires a valid certificate (self-signed certificates don't work)
- Use Let's Encrypt (free) to get a valid certificate

### Database errors

```bash
rails db:drop
rails db:create
rails db:migrate
rails db:seed
```

```bash
./bin/dev
```

To test the webhook locally, use ngrok:

```bash
ngrok http 3000
```

Then update your Telegram webhook with the ngrok URL.

## Future Enhancements

- User preferences and favorite quotes
- Share quotes to social media
- Quote of the day notifications
- Custom quotes submission
- Multi-language support
- Statistics and analytics
- Admin dashboard for managing quotes

## License

This project is open source and available under the MIT License.

## Support

For issues or questions, please open an issue in the repository.
