class CustomFailure < Devise::FailureApp
  UNAUTHORIZED_ERROR_TITLE = 'Login Failed!'
  def respond
    if request.env['CONTENT_TYPE'] == 'application/vnd.api+json'
      self.status = :unauthorized
      self.response_body = {errors: [status: 401, title: UNAUTHORIZED_ERROR_TITLE]}.to_json
      self.content_type = "json"
    else
      super
    end
  end

end
