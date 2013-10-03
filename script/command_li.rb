class Cli
  def self.run
    email = ask_user_for_email
    loop do
      user = find_user_by_email(email)

      selection = ask_user_for_selection

      selection == "0" ? create_shortened_url(user) : visit_shortened_url(user)
    end
  end

  def self.find_user_by_email(email)
    User.find_by_email(email)
  end

  def self.ask_user_for_email
    email = ""
    until email.match(/^.+@.+$/)
      puts "Input your email:"
      email = gets.chomp
    end
    email
  end

  def self.ask_user_for_selection
    selection = ""
    until selection.match(/^[01]$/)
      puts "What do you want to do?"
      puts "0. Create shortened URL"
      puts "1. Visit shortened URL"
      selection = gets.chomp
    end

    selection
  end

  def self.create_shortened_url(user)
    long_url = ask_user_for_long_url
    short_url = ShortenedUrl.create_for_user_and_long_url!(user, long_url).short_url
    puts "Short url is: "
    print short_url + "\n"
  end

  def self.ask_user_for_long_url
    long_url = ""
    until long_url.match(/https?:\/\/[\S]+/)
      puts "Type in your long url:"
      long_url = gets.chomp
    end
    long_url
  end

  def self.visit_shortened_url(user)
    short_url = ask_user_for_short_url
    url_object = ShortenedUrl.find_by_short_url(short_url)

    Launchy.open(url_object.long_url)
    record_visit_to_url(user, url_object)
  end

  def self.ask_user_for_short_url
    short_url = ""
    until short_url.match(/(.)+/)
      puts "Type in your short url:"
      short_url = gets.chomp
    end
    short_url
  end

  def self.record_visit_to_url(user, shortened_url)
    Visit.record_visit!(run user, shortened_url)
  end
end