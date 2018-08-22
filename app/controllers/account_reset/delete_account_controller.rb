module AccountReset
  class DeleteAccountController < ApplicationController
    before_action :check_feature_enabled

    def show
      render :show and return unless token

      result = AccountReset::ValidateGrantedToken.new(token).call
      analytics.track_event(Analytics::ACCOUNT_RESET, result.to_h)

      if result.success?
        handle_valid_token
      else
        handle_invalid_token(result)
      end
    end

    def delete
      granted_token = session.delete(:granted_token)
      result = AccountReset::DeleteAccount.new(granted_token).call
      analytics.track_event(Analytics::ACCOUNT_RESET, result.to_h.except(:email))

      if result.success?
        handle_successful_deletion(result)
      else
        handle_invalid_token(result)
      end
    end

    private

    def check_feature_enabled
      redirect_to root_url unless FeatureManagement.account_reset_enabled?
    end

    def token
      params[:token]
    end

    def handle_valid_token
      session[:granted_token] = token
      redirect_to url_for
    end

    def handle_invalid_token(result)
      flash[:error] = result.errors[:token].first
      redirect_to root_url
    end

    def handle_successful_deletion(result)
      sign_out
      flash[:email] = result.extra[:email]
      redirect_to account_reset_confirm_delete_account_url
    end
  end
end
