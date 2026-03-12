# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @app_name = 'MyStandMap'
    mail(
      to: @user.email,
      subject: "Welcome to #{@app_name}!"
    )
  end

  def password_reset(user, reset_token)
    @user = user
    @reset_token = reset_token
    @app_name = 'MyStandMap'
    @expire_hours = 2
    mail(
      to: @user.email,
      subject: "Reset your #{@app_name} password"
    )
  end
end
