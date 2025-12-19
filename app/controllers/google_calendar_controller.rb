class GoogleCalendarController < ApplicationController
  require 'google/apis/calendar_v3'
  require 'google/api_client/client_secrets'

  def connect
    client_secrets = Google::APIClient::ClientSecrets.new(
      { "web" => {
          "client_id" => GOOGLE_CLIENT_ID,
          "client_secret" => GOOGLE_CLIENT_SECRET,
          "redirect_uris" => [GOOGLE_REDIRECT_URI]
        }
      }
    )

    auth_client = client_secrets.to_authorization
    auth_client.update!(
      scope: 'https://www.googleapis.com/auth/calendar',
      redirect_uri: GOOGLE_REDIRECT_URI
    )

    redirect_to auth_client.authorization_uri.to_s
  end

  def callback
    client_secrets = Google::APIClient::ClientSecrets.new(
      { "web" => {
          "client_id" => GOOGLE_CLIENT_ID,
          "client_secret" => GOOGLE_CLIENT_SECRET,
          "redirect_uris" => [GOOGLE_REDIRECT_URI]
        }
      }
    )

    auth_client = client_secrets.to_authorization
    auth_client.update!(
      scope: 'https://www.googleapis.com/auth/calendar',
      redirect_uri: GOOGLE_REDIRECT_URI
    )

    auth_client.code = params[:code]
    auth_client.fetch_access_token!

    session[:google_access_token] = auth_client.access_token
    redirect_to dashboard_path, notice: 'Google Calendar connected successfully.'
  end
end