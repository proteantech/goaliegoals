class SessionsController < Devise::SessionsController

  def create
    if json_api_request?
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      render json: {authentication_token: current_user.authentication_token}
    else
      super
    end
  end

  private

  def json_api_request?
    request.env['CONTENT_TYPE'] == 'application/vnd.api+json'
  end

end