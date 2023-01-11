require "uri"
require "json"
require "net/http"

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :animes
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_anime_watched

  def create_anime_watched
    if anilist_account
      url = URI("https://graphql.anilist.co/")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Cookie"] = "laravel_session=o2UYRsf3cZoofqSBY1WjaTfJFP0AbJkvKQffyp6X"
      request.body = "{\"query\":\"query ($userId: Int, $userName: String) { User(id: $userId, name: $userName){ mediaListOptions{ scoreFormat } } MediaListCollection(userId: $userId, userName: $userName, type: ANIME, status: COMPLETED, sort: SCORE_DESC){ lists{ entries{ score repeat mediaId } } } }\",\"variables\":{\"userName\":\"#{anilist_account}\"}}"
      response = https.request(request)
      format = JSON.parse(response.read_body)['data']['User']['mediaListOptions']['scoreFormat']
      self.score_format = format
      save
      JSON.parse(response.read_body)['data']['MediaListCollection']['lists'][0]['entries'].each do |anime|
        puts self
        Anime.create(user_id: id, anime_url: anime['mediaId'], repeat: anime['repeat'], my_score: anime['score'])
      end
    end
  end
end
