require "open-uri"
require "json"

USER_AGENT = "MeowLibrary student project (github.com/mmera21)".freeze
BOOKS_PER_GENRE = 20

# Gnres -> open library subject
GENRES = {
  "Fiction" => "fiction",
  "Non-Fiction" => "history",
  "Science" => "science",
  "Children" => "children",
  "Cooking" => "cooking",
  "Self Help" => "self-help"
}.freeze

# helpers

def fetch_json(url)
  JSON.parse(URI.open(url, "User-Agent" => USER_AGENT).read)
rescue StandardError => e
  puts "  ! Could not load #{url}: #{e.message}"
  nil
end

# can come with strings
def work_description(work_key)
  data = fetch_json("https://openlibrary.org#{work_key}.json")
  return nil if data.nil?

  text = data["description"]
  text = text["value"] if text.is_a?(Hash)
  return nil if text.blank?

  text.split("----------").first.strip.truncate(1500)
end

# taxes rates
puts "Seeding provinces..."
[
  ["Alberta", "AB", 0.05, 0, 0],
  ["British Columbia", "BC", 0.05, 0.07, 0],
  ["Manitoba", "MB", 0.05, 0.07, 0],
  ["New Brunswick", "NB", 0, 0, 0.15],
  ["Newfoundland and Labrador", "NL", 0, 0, 0.15],
  ["Northwest Territories", "NT", 0.05, 0, 0],
  ["Nova Scotia", "NS", 0, 0, 0.14],
  ["Nunavut", "NU", 0.05, 0, 0],
  ["Ontario", "ON", 0, 0, 0.13],
  ["Prince Edward Island", "PE", 0, 0, 0.15],
  ["Quebec", "QC", 0.05, 0.09975, 0],
  ["Saskatchewan", "SK", 0.05, 0.06, 0],
  ["Yukon", "YT", 0.05, 0, 0]
].each do |name, code, gst, pst, hst|
  province = Province.find_or_initialize_by(code: code)
  province.update!(name: name, gst_rate: gst, pst_rate: pst, hst_rate: hst)
end

# About and contact pages 
puts "Seeding pages..."
Page.find_or_create_by!(slug: "about") do |page|
  page.title = "About Meow Library"
  page.content = "Meow Library is a cat friendly independent bookstore in Osborne Village, Winnipeg. " \
                 "Since 2009 our team of eight book lovers, and our resident cats Frutilla and Mango, " \
                 "have helped readers find their next favourite book."
end
Page.find_or_create_by!(slug: "contact") do |page|
  page.title = "Contact Us"
  page.content = "Visit us in Osborne Village, Winnipeg MB. Email hello@meowlibrary.ca " \
                 "or call (204) 555-0142. Open every day from 10 am to 8 pm."
end

# Here the categories and products 
GENRES.each do |genre_name, subject|
  category = Category.find_or_create_by!(name: genre_name)
  print "Seeding #{genre_name} "

  data = fetch_json("https://openlibrary.org/subjects/#{subject}.json?limit=50")
  next if data.nil?

  added = 0
  data["works"].each do |work|
    break if added >= BOOKS_PER_GENRE

    author = work.dig("authors", 0, "name")
    next if author.blank? || work["cover_id"].blank?

    product = Product.find_or_initialize_by(open_library_key: work["key"])

    if product.new_record?
      description = work_description(work["key"])
      next if description.blank? # real descriptions only

      price = rand(12..34) + 0.99
      on_sale = rand < 0.2
      product.assign_attributes(
        title: work["title"].truncate(255),
        author: author,
        description: description,
        price: price,
        on_sale: on_sale,
        sale_price: on_sale ? (price * 0.8).round(2) : nil,
        cover_id: work["cover_id"],
        created_at: rand(5..120).days.ago
      )
      product.updated_at = product.created_at
      product.save!
    end

    product.categories << category unless product.categories.include?(category)
    added += 1
    print "."
  end

  puts " #{added} books"
end

# covers p
print "Attaching covers "
Product.where.not(cover_id: nil).find_each do |product|
  next if product.image.attached?

  url = "https://covers.openlibrary.org/b/id/#{product.cover_id}-L.jpg"
  product.image.attach(io: URI.open(url, "User-Agent" => USER_AGENT),
                       filename: "cover-#{product.cover_id}.jpg", content_type: "image/jpeg")
  print "."
rescue StandardError => e
  puts "\n  ! Cover for #{product.title}: #{e.message}"
end
puts

# admin user 
AdminUser.find_or_create_by!(email: "admin@meowlibrary.ca") do |admin|
  admin.password = "password123"
  admin.password_confirmation = "password123"
end
puts "Admin: admin@meowlibrary.ca / password123"

puts "Done! #{Category.count} categories, #{Product.count} products, #{Province.count} provinces."