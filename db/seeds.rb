# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing quotes
Quote.destroy_all

quotes = [
  # Motivation
  { text: "The only way to do great work is to love what you do.", author: "Steve Jobs", category: "Motivation" },
  { text: "Innovation distinguishes between a leader and a follower.", author: "Steve Jobs", category: "Motivation" },
  { text: "Life is what happens when you're busy making other plans.", author: "John Lennon", category: "Motivation" },
  { text: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt", category: "Motivation" },
  
  # Success
  { text: "Success is not final, failure is not fatal.", author: "Winston Churchill", category: "Success" },
  { text: "It is during our darkest moments that we must focus to see the light.", author: "Aristotle", category: "Success" },
  { text: "The only impossible journey is the one you never begin.", author: "Tony Robbins", category: "Success" },
  { text: "Success usually comes to those who are too busy to be looking for it.", author: "Henry David Thoreau", category: "Success" },
  
  # Wisdom
  { text: "The only true wisdom is in knowing you know nothing.", author: "Socrates", category: "Wisdom" },
  { text: "An unexamined life is not worth living.", author: "Socrates", category: "Wisdom" },
  { text: "The mind is everything. What you think, you become.", author: "Buddha", category: "Wisdom" },
  { text: "Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.", author: "Buddha", category: "Wisdom" },
  
  # Courage
  { text: "Courage is not the absence of fear, but rather the assessment that something else is more important than fear.", author: "Franklin D. Roosevelt", category: "Courage" },
  { text: "You gain strength, courage, and confidence by every experience.", author: "Eleanor Roosevelt", category: "Courage" },
  { text: "Brave is the lion that roars; braver still is the one that rises after falling.", author: "Unknown", category: "Courage" },
  
  # Friendship
  { text: "A friend is one who knows you and loves you just the same.", author: "Elbert Hubbard", category: "Friendship" },
  { text: "True friendship is not about being inseparable, it's about being separated and nothing changes.", author: "Unknown", category: "Friendship" },
  { text: "In the end, we will remember not the words of our enemies, but the silence of our friends.", author: "Martin Luther King Jr.", category: "Friendship" },
  
  # Love
  { text: "The heart wants what it wants.", author: "Woody Allen", category: "Love" },
  { text: "Love all, trust a few, do wrong to none.", author: "William Shakespeare", category: "Love" },
  { text: "Love is the bridge between two hearts.", author: "Unknown", category: "Love" },
]

quotes.each do |quote_attrs|
  Quote.find_or_create_by!(text: quote_attrs[:text]) do |quote|
    quote.author = quote_attrs[:author]
    quote.category = quote_attrs[:category]
  end
end

puts "✅ Seeded #{Quote.count} quotes"
