json.array!(@seasons) do |season|
  json.extract! season, :id
  json.url season_url(season, format: :json)
end
