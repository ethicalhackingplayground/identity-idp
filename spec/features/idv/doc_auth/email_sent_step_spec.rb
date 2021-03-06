require 'rails_helper'

feature 'doc auth email sent step' do
  include IdvStepHelper
  include DocAuthHelper

  before do
    enable_doc_auth
    sign_in_and_2fa_user
    complete_doc_auth_steps_before_email_sent_step
  end

  it 'is on the correct page' do
    expect(page).to have_current_path(idv_doc_auth_email_sent_step)
    user = User.first
    expect(page).to have_content(t('doc_auth.instructions.email_sent', email: user.email))
  end
end
