from bottle import route, run, template

@route('/hello/<name>')
def index(name):
    return template('<b>Hello {{name}}</b>!', name=name)

@route('/')
def hello():
    return "Hello World!"

run(host='localhost', port=8080)

