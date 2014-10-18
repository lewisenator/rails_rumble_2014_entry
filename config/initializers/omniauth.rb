Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, 'd3386a88ddb0d69e0695', '735646a27225a4f5d3e884424a1c81f7ee252ad3',
           :scope => 'user'
end