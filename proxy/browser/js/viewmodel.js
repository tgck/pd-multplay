var vm = new Vue({
  el: '#demo',
  data: {
    message: 'Hello Vue.js!',
    command: 'pd dsp 1',
    response: '(result)',
    session: {
      url: '/cmd',
      param: {
        q:''
      }
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
      }, {
        title: '[ext] List canvases.',
        message: 'pd ls;'
      }, {
        title: '[ext] Get the frontmost patch as text',
        message: '(not implemented)'
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
      this.session.param.q = this.ta;
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

var vm2 = new Vue({
  el : '#receiver',
  data: {
    bReceive : false,
    url : "http://localhost:8080/recv",
    interval: 3000
  },
  methods : {
    switch: function(){
      // メッセージ受信のAjaxリクエストを開始する
      if (this.bReceive) {
        getMessages();
      }
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
      //'dataType': 'json',
      //'data' : JSON.stringify(vm.$data.ta)
      'data' : vm.$data.session.param
  }).done(function(data){
      console.log("kickAjax() ... success");
      console.log(data);
      vm.$data.response = data;
      showReqResult(data);
  }).fail(function(data){
      console.log("kickAjax() ... fail");
  });
}
////////////////////////////////////////////////////
// Getting Result
////////////////////////////////////////////////////
var getMessages = function(){
  $.ajax({
    'url' : vm2.$data.url,
    'method' : "GET"
  }).done(function(data){
    console.log("getMessages() ... success");
    showMessage(data);

    setTimeout(getMessages, vm2.$data.interval);
    console.log("receiving...");
  }).fail(function(data){
    console.log("getMessages() ... fail");
  });
}

var showReqResult = function(data) {
  // toastr.info('Are you the 6 fingered man?');
  toastr.info(data);
}
var showMessage = function(data){
  toastr.success(data);
}
