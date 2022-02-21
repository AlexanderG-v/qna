require 'rails_helper'

RSpec.describe NotificationService do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, author: user, question: question) }

  it 'sends notification of a new answer to a question' do
    create(:subscription, user: user, question: question)

    question.subscriptions.each do |subscription|
      expect(NotificationMailer).to receive(:subscribe_question).with(subscription.user, answer).and_call_original
    end
    subject.send_notification(answer)
  end
end
