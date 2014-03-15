require "spec_helper"

describe UserMailer do
  describe "activation_email" do
    let(:user) { FactoryGirl.create(:pending_user) }
    let(:mail) { UserMailer.activation_email(user.id) }


    it "renders the headers" do
      expect(mail.subject).to eq I18n.t('user_mailer.activation_email.subject')
      expect(mail.to).to eq [user.email]
      expect(mail.from[0]).to match 'no-reply@it3s.mailgun.org'
    end

    it { expect(mail.body.encoded).to match user.name }
    it { expect(mail.body.encoded).to match user.activation_token }
  end

end
