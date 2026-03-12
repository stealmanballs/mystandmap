# frozen_string_literal: true

class ClaimMailer < ApplicationMailer
  def claim_submitted(claim)
    @claim = claim
    @stand = claim.stand
    @user = claim.user
    @app_name = 'MyStandMap'
    mail(
      to: @user.email,
      subject: "Your claim for #{@stand.name} has been submitted"
    )
  end

  def claim_approved(claim)
    @claim = claim
    @stand = claim.stand
    @user = claim.user
    @app_name = 'MyStandMap'
    mail(
      to: @user.email,
      subject: "Your claim for #{@stand.name} has been approved!"
    )
  end

  def claim_rejected(claim)
    @claim = claim
    @stand = claim.stand
    @user = claim.user
    @app_name = 'MyStandMap'
    mail(
      to: @user.email,
      subject: "Your claim for #{@stand.name} has been rejected"
    )
  end

  def admin_new_claim(claim)
    @claim = claim
    @stand = claim.stand
    @user = claim.user
    @app_name = 'MyStandMap'
    mail(
      to: ENV.fetch('ADMIN_NOTIFICATION_EMAIL', 'admin@mystandmap.com'),
      subject: "New claim for #{@stand.name} - requires review"
    )
  end
end
