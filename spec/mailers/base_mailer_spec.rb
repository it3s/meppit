require "spec_helper"

describe BaseMailer do
  it { expect(BaseMailer._layout).to eq 'mail' }

  it { expect(BaseMailer.default_params[:from]).to eq 'Meppit <no-reply@it3s.mailgun.org>' }

  describe "sidekiq delay options" do
    it 'sets the queue to :mailer' do
      BaseMailer.should receive(:sidekiq_delay).with(:queue => 'mailer')
      BaseMailer.delay
    end
  end

  describe ".email_with_name" do
    let(:user) { FactoryGirl.build(:user, :name => 'Donald Duck', :email => 'donald@quackmail.com') }
    it { expect(BaseMailer.email_with_name user ).to eq "Donald Duck <donald@quackmail.com>" }
  end

end
