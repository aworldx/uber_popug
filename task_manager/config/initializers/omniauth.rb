Rails.application.config.middleware.use OmniAuth::Builder do
  provider OmniAuth::Strategies::Keepa, Settings['APP_KEY'], Settings['APP_SECRET'], { scope: 'public' }
end
