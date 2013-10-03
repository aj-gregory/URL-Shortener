class ShortenedUrl < ActiveRecord::Base

  attr_accessible :long_url, :submitter_id, :short_url

  validates :long_url, presence: true
  validates :short_url, uniqueness: true
  validates :submitter_id, presence: true

  belongs_to :submitter,
    :class_name => "User",
    :primary_key => :id,
    :foreign_key => :submitter_id

  has_many :visits,
      :class_name => "Visit",
      :primary_key => :id,
      :foreign_key => :visited_url_id

  has_many :visitors, :through => :visits, :source => :visitor, :uniq => true

  def self.random_code
    random_string = SecureRandom.urlsafe_base64(12)

    while ShortenedUrl.where(:short_url => random_string).count > 0
      random_string = SecureRandom.urlsafe_base64(12)
    end

    random_string
  end

  def self.create_for_user_and_long_url!(user, long_url)
    random_string = ShortenedUrl.random_code
    short_url = ShortenedUrl.create(
      :long_url => long_url,
      :submitter_id => user.id,
      :short_url => random_string
    )
    short_url.save!
    short_url
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    visits.where(:created_at => (10.minutes.ago..Time.now)).count('DISTINCT visitor_id')
  end
end
