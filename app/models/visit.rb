class Visit < ActiveRecord::Base
  attr_accessible :visited_url_id, :visitor_id

  belongs_to :visitor,
    :class_name => "User",
    :primary_key => :id,
    :foreign_key => :visitor_id

  belongs_to :url,
    :class_name => "ShortenedUrl",
    :primary_key => :id,
    :foreign_key => :visited_url_id

    def self.record_visit!(user, shortened_url)
      Visit.create({:visited_url_id => shortened_url.id, :visitor_id => user.id})
    end
end
