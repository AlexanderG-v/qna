import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {

  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    connected() {
      console.log('AnswersChannel connected');
    },

    disconnected() {
      console.log('AnswersChannel disconnected');
    },

    received(data) {
      this.appendLine(data)
    },
    
    appendLine(data) {
      const html = this.createLine(data)
      $('.answers tbody').append(html)
    },

    createLine(data) {
      return `
        <tr class=".other-answers">
        <tr class="answer-id-${data.answer.id}">
        <td>${data.answer.body}</td>
        `
    }
  });
})
