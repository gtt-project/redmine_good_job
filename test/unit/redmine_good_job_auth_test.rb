# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

# Tests for the Rack middleware that gates the GoodJob dashboard so that only
# logged-in admin users can reach it. User lookups are stubbed, so these are
# fast unit tests that do not depend on database rows.
class RedmineGoodJobAuthTest < ActiveSupport::TestCase
  def setup
    @app = ->(_env) { [200, { 'Content-Type' => 'text/plain' }, ['ok']] }
    @middleware = RedmineGoodJobAuth.new(@app)
  end

  # Build a Rack response by calling the middleware for the given path/session.
  def call(path, user_id: nil)
    env = Rack::MockRequest.env_for(path, 'rack.session' => { user_id: user_id })
    @middleware.call(env)
  end

  test 'passes through requests outside /good_job without checking the user' do
    User.expects(:find_by).never
    status, _headers, body = call('/projects')
    assert_equal 200, status
    assert_equal ['ok'], body
  end

  test 'allows an admin user to reach the dashboard' do
    User.stubs(:find_by).returns(User.new(admin: true))
    status, _headers, body = call('/good_job/jobs', user_id: 1)
    assert_equal 200, status
    assert_equal ['ok'], body
  end

  test 'redirects a non-admin user to the login page' do
    User.stubs(:find_by).returns(User.new(admin: false))
    status, headers, _body = call('/good_job/jobs', user_id: 2)
    assert_equal 302, status
    assert_includes headers['Location'], '/login'
    assert_includes headers['Location'], 'back_url'
  end

  test 'redirects an anonymous request to the login page' do
    User.stubs(:find_by).returns(nil)
    status, headers, _body = call('/good_job')
    assert_equal 302, status
    assert_includes headers['Location'], '/login'
  end

  test 'treats a user lookup error as not authorized' do
    User.stubs(:find_by).raises(StandardError, 'boom')
    status, _headers, _body = call('/good_job/jobs', user_id: 1)
    assert_equal 302, status
  end
end
