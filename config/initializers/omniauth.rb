Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['450065025195002'], ENV['471dde9c2358570914c055d1ea12fd83']
end