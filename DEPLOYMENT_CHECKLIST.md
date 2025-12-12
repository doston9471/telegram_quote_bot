# Deployment Checklist

## Pre-Deployment ✅

- [ ] Clone repository
- [ ] Run `bundle install`
- [ ] Create `.env` file from `.env.example`
- [ ] Get Telegram bot token from @BotFather
- [ ] Add `TELEGRAM_BOT_TOKEN` to `.env`
- [ ] Run `rails db:create db:migrate db:seed`
- [ ] Test locally: `rails runner script/test_bot.rb`
- [ ] Verify all 11 commands work

## Deployment to Heroku

### 1. Create Heroku App
```bash
heroku create your-quote-bot-name
heroku addons:create heroku-postgresql:mini
```

### 2. Configure Environment
```bash
heroku config:set TELEGRAM_BOT_TOKEN=your_token_here
heroku config:set TELEGRAM_BOT_WEBHOOK_URL=https://your-quote-bot-name.herokuapp.com/telegram/webhook
```

### 3. Deploy Code
```bash
git push heroku main
```

### 4. Setup Database
```bash
heroku run rails db:migrate
heroku run rails db:seed
```

### 5. Register Webhook
```bash
heroku run rails telegram:set_webhook
```

### 6. Verify Webhook
```bash
heroku run rails telegram:webhook_info
```

## Deployment to AWS EC2

### 1. Launch Instance
- Ubuntu 20.04 LTS
- t2.micro or better
- Security group: Allow HTTP (80), HTTPS (443)

### 2. Install Dependencies
```bash
sudo apt update
sudo apt install -y ruby-full build-essential sqlite3
sudo gem install bundler rails
```

### 3. Clone & Setup
```bash
git clone <your-repo>
cd telegram_quote_bot
bundle install
```

### 4. Configure Environment
```bash
cp .env.example .env
# Edit .env with your token
```

### 5. Setup Database
```bash
rails db:create db:migrate db:seed
```

### 6. Configure SSL (Let's Encrypt)
```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot certonly --standalone -d your-domain.com
```

### 7. Run Rails with Nginx
- Configure Nginx as reverse proxy
- Point to Rails on port 3000

### 8. Register Webhook
```bash
TELEGRAM_BOT_TOKEN=your_token \
TELEGRAM_BOT_WEBHOOK_URL=https://your-domain.com/telegram/webhook \
rails telegram:set_webhook
```

## Docker Deployment

### 1. Build Image
```bash
docker build -t telegram-quote-bot .
```

### 2. Run Container
```bash
docker run -e TELEGRAM_BOT_TOKEN=your_token \
           -e TELEGRAM_BOT_WEBHOOK_URL=https://your-domain.com/telegram/webhook \
           -p 3000:3000 \
           telegram-quote-bot
```

### 3. With Docker Compose
Create `docker-compose.yml`:
```yaml
version: '3'
services:
  bot:
    build: .
    environment:
      TELEGRAM_BOT_TOKEN: your_token
      TELEGRAM_BOT_WEBHOOK_URL: https://your-domain.com/telegram/webhook
    ports:
      - "3000:3000"
```

Then: `docker-compose up`

## Post-Deployment Verification

### 1. Check Webhook Status
```bash
rails telegram:webhook_info
# Should show: Pending update count: 0
```

### 2. Test Bot
Open Telegram and send `/start` to your bot
- Should receive welcome message
- Try `/help` to see all commands
- Try `/random` to get a quote

### 3. Monitor Logs
```bash
# Heroku
heroku logs --tail

# AWS/Traditional
tail -f log/production.log
```

### 4. Check Database
```bash
rails console

# In console:
Quote.count        # Should be 21
Quote.all_categories  # Should show 6 categories
```

## Troubleshooting

### Bot Not Responding

1. Check webhook is registered:
   ```bash
   rails telegram:webhook_info
   ```

2. Check for errors in logs:
   ```bash
   heroku logs --tail
   # or
   tail -f log/production.log
   ```

3. Verify environment variables:
   ```bash
   heroku config
   ```

4. Restart the service:
   ```bash
   heroku restart
   ```

### Database Issues

```bash
# Reset database
rails db:drop db:create db:migrate db:seed

# Verify quotes loaded
rails console
Quote.count
```

### HTTPS/SSL Issues

- Ensure your domain has valid SSL certificate
- Test with: `curl -I https://your-domain.com`
- Update `TELEGRAM_BOT_WEBHOOK_URL` to use `https://`

## Scaling Recommendations

### If Traffic Increases:
1. Enable Rails caching in production
2. Use horizontal scaling (load balancer)
3. Consider background jobs for quote delivery
4. Implement user analytics

### Performance Optimization:
```ruby
# Add to config/environments/production.rb
config.cache_classes = true
config.cache_store = :memory_store
```

## Monitoring

### Uptime Monitoring:
- Use Uptime Robot to monitor: `https://your-domain.com/up`
- Set alerts for downtime

### Error Tracking:
- Consider Sentry for error monitoring
- Add: `gem 'sentry-rails'` to Gemfile

### Analytics:
- Track bot usage in database
- Log user commands and responses

## Backup Strategy

### Database Backups:
```bash
# Heroku
heroku pg:backups:capture
heroku pg:backups:download

# Manual backup
rails db:dump
```

### Code Backup:
- Keep repository up to date
- Push to GitHub regularly
- Tag releases

## Maintenance

### Regular Tasks:
- [ ] Monitor logs weekly
- [ ] Check webhook status monthly
- [ ] Review error logs
- [ ] Update gems quarterly: `bundle update`

### Adding Quotes:
1. Edit `db/seeds.rb`
2. Run `rails db:seed` (adds new, keeps existing)
3. Deploy changes
4. Verify with: `rails console` → `Quote.count`

## Rollback Procedure

### If Issues After Deployment:

**Heroku:**
```bash
heroku releases  # See history
heroku rollback v123  # Rollback to version
```

**Manual:**
- Keep previous version tag in git
- Git rollback: `git revert <commit>`
- Redeploy

## Success Checklist

- [ ] Webhook registered successfully
- [ ] All commands working
- [ ] No errors in logs
- [ ] Database has 21 quotes
- [ ] Bot responds within 1 second
- [ ] 24/7 uptime maintained
- [ ] Users can see responses

---

**Deployment Guide Complete!** 🚀

For issues, check TELEGRAM_BOT_SETUP.md or troubleshoot with:
```bash
rails telegram:webhook_info
tail -f log/production.log
rails console
```
