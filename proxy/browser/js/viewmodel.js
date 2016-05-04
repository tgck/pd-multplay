var vm = new Vue({
  el: '#demo',
  data: {
    message: 'Hello Vue.js!',
    command: 'pd dsp 1',
    response: '(result)',
    session: {
      // url: '/command',
      param: {}
    }
  },
  methods: {
    kick: function(){
      kickAjax();
    }
  }
})

////////////////////////////////////////////////////
// Reach to Endpoint
////////////////////////////////////////////////////
var kickAjax = function(){

  url = "http://localhost:8080/command"

  $.ajax ({
      'url' : url,
      'method' : "GET",
      'data' : vm.$data.command
  }).done(function(data){
      console.log("kickAjax() ... success");
      console.log(data);
      vm.$data.response = data;
  }).fail(function(data){
      console.log("kickAjax() ... fail");
  });
}
