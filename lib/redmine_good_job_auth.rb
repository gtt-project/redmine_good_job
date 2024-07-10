class RedmineGoodJobAuth
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if good_job_request?(request) && !admin_user_logged_in?(request.session)
      redirect_to_login(request)
    else
      @app.call(env)
    end
  end

  private

  def good_job_request?(request)
    request.path.start_with?('/good_job')
  end

  def admin_user_logged_in?(session)
    user_id = session[:user_id]
    user = User.find_by(id: user_id)
    user && user.admin?
  rescue
    false
  end

  def redirect_to_login(request)
    [302, { 'Location' => login_url(request), 'Content-Type' => 'text/html' }, []]
  end

  def login_url(request)
    "#{request.base_url}/login?back_url=#{CGI.escape(request.fullpath)}"
  end
end
