require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let!(:user) { create :user }
    let!(:question) { create_list(:question, 3, author: user) }
    let(:mail) { described_class.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Daily digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end
  end

  it 'renders the body' do
    expect(mail.body.encoded).to match('Hi')
  end
end
