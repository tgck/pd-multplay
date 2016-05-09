var vm = new Vue({
  el: '#demo',
  data: {
    message: 'Hello Vue.js!',
    command: 'pd dsp 1',
    response: '(result)',
    session: {
      // url: '/command',
      param: {}
    },
    selected: '',
    commands: [
      {
        title: 'Turn DSP on',
        message: 'pd dsp 1;'
      },{
        title: 'Turn DSP off',
        message: 'pd dsp 0;'
      },{
        title: 'Open a patch file',
        message: 'pd open Untitled-2.pd /Users/tani/Desktop;'
      }
    ]
  },
  computed: {
    ta: function(){
      target = this.selected;
      where = _.findIndex(this.commands, function(val){return val.title == target });
      return ( where == -1 ) ? '' : this.commands[where]['message'];
    }
  },
  methods: {
    send: function(){
      kickAjax();
    },
    kick: function(){
      kickAjax();
    },
    hoge: function(){
      alert($index);
    }
  }
})

////////////////////////////////////////////////////
// Reach to Endpoint
////////////////////////////////////////////////////
var kickAjax = function(){

  url = "http://localhost:8080/cmd"

  $.ajax ({
      'url' : url,
      'method' : "GET",
      //'data' : JSON.stringify(vm.$data.command)
      'data' : JSON.stringify(vm.$data.ta)
  }).done(function(data){
      console.log("kickAjax() ... success");
      console.log(data);
      vm.$data.response = data;
  }).fail(function(data){
      console.log("kickAjax() ... fail");
  });
}
