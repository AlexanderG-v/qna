import consumer from './consumer';

document.addEventListener('turbolinks:load', () => {
  consumer.subscriptions.create({ channel: 'QuestionsChannel' } , {
    connected() {
        console.log('QuestionsChannel connected');
    },

    disconnected() {
        console.log('QuestionsChannel disconnected');
    },

    received(data) {
        document.querySelector('.question-items')
            .insertAdjacentHTML('afterbegin', data)
    }
  })
})
